# -*- coding: utf-8 -*-
module Mongoid
  module Count
    extend ActiveSupport::Concern

    included do
    end

    module InstanceMethods
      def map
        map = %Q{
        function() {
          for (var checkin in this.checkins){
            emit(this.staffid,this.checkins[checkin].behave_id);
          }
        }
        }
      end

      def reduce
        reduce = %Q{
        function(key, values) {
          return {ids:values};
        }
        }
      end
    end

    module  ClassMethods 
    end
  end
end
