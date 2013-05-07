# -*- coding: utf-8 -*-
class ApplicationController <  ApplicationWithExceptionsController

  protect_from_forgery
  before_filter :browser_filter unless Rails.env.test?
  before_filter CASClient::Frameworks::Rails::Filter

  authorize_resource
  skip_authorize_resource :only => :logout

  helper_method :current_user

  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    @user ||= User.resource(attrs["SU_USER_ID"]).perssion(attrs["roles"])
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end

