# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
#  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_user

  def current_user
   @current_user = User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

    def sort_by_field v,field
      v.sort_by! do |v|
        v[field]
      end
  end
end
