# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_user
#  load_and_authorize_resource
#  check_authorization 
 
#  authorize!
#  authorize_resource


  check_authorization
 

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url , :alert => exception.message
  end




  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    Permission.assign attrs["role"]
    User.current_user = User.resource(attrs)
  end 

  def available? var
   var.empty?  ? nil : var  if var
  end

  def logout
    session = nil
    CASClient::Frameworks::Rails::Filter.logout(self)
  end




end
