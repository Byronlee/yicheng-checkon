# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :current_user

  def current_user
  #  @current_user = User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
    attrs = session[:cas_extra_attributes]["attrs"]
    @current_user = User.resource(attrs)
    User.current_user = @current_user 
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
end
