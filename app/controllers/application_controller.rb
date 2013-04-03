# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_user
#  load_and_authorize_resource

  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    Permission.assign attrs["role"]
    User.current_user = User.resource(attrs)
  end 

  def available? var
   var.empty?  ? nil : var  if var
  end

end
