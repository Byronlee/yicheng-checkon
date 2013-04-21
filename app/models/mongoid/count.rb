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
        return Moped::BSON::ObjectId.from_string(ids) if ids.instance_of? String 
        ids.map{|id|Moped::BSON::ObjectId.from_string(id)}
      end

      def count_result id
        self.where("_id.behave_id"  => convert_object(id))
      end
    end
  end
end
