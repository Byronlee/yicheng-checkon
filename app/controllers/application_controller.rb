# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter

  authorize_resource
  skip_authorize_resource :only => :logout

  before_filter :current_user


  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    Permission.assign attrs["role"]
    User.current_user = User.resource(attrs)
  end 

  def available? var
   var.empty?  ? nil : var  if var
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url , :alert => exception.message
  end
end
