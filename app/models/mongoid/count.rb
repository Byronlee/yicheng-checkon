# -*- coding: utf-8 -*-
module Mongoid
  module Count
    extend ActiveSupport::Concern

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

      def finalize
        %Q{
        function(key, values) {
          if(!values.count){
            return  {count: 1 , record_ids: [values]}
            }
          return  values;
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
    end
  end
end
