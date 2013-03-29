# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_user

  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    p "++++++++++++++++++++++++++"
    p attrs
    Permission.assign attrs["role"]
    User.current_user =  @current_user = User.resource(attrs)
  end 
  
  def sort_by_field v,field
    return  if v.empty?
    v.sort_by! do |v|
      v[field]
    end
  end

  def available? var
   var.empty?  ? nil : var  if var
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
