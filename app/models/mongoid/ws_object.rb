# -*- coding: utf-8 -*-
module Mongoid
  module WsObject
    extend ActiveSupport::Concern
    
    module InstanceMethods

      def method_missing(field_name)
        name = Settings.user_attrs[field_name]
        super unless @data[name]
        @data[name]
      end
   end
  end
end

