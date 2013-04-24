# -*- coding: utf-8 -*-
module Mongoid
  module Count
    extend ActiveSupport::Concern

   module InstanceMethods

   end

   module  ClassMethods 
     def map
       map = %Q{
        function() {
          for (var checkin in this.checkins){
            emit({"behave_id": this.checkins[checkin].behave_id,"user_id": this.staffid}, this._id);
          }
        }
        }
     end

     def reduce
       reduce = %Q{
        function(key, values) {
          return {count: values.length , record_ids: values};
        }
        }
     end


      def convert_object ids    
        if ids.instance_of? Array
          ids.map{|id|Moped::BSON::ObjectId.from_string(id)}
        else
          Moped::BSON::ObjectId.from_string(ids)
        end
      end

     def count_result current_user ,id
       if id.instance_of? String           
         return  self.where("_id.behave_id"  => convert_object(id)) if current_user.approval?
         self.in("_id.user_id" => current_user.users_with_subdept ).where("_id.behave_id"  => convert_object(id)) 
       else
         return self.in("_id.behave_id"  => convert_object(Settings.leave_behave_ids)) if current_user.approval?
         self.in("_id.user_id" => current_user.users_with_subdept).in("_id.behave_id"  => convert_object(Settings.leave_behave_ids))
       end
     end
   end
 end
end
