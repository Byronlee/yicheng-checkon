# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
require 'casclient'
require 'casclient/frameworks/rails/filter'
# Initialize the rails application
Attendance::Application.initialize!
# enable detailed CAS logging
#cas_logger = CASClient::Logger.new(::Rails.root+'/log/cas.log')
#cas_logger.level = Logger::DEBUG



# CASClient::Frameworks::Rails::Filter.configure(:cas_base_url => "http://iphelper.cdu.edu.cn/sso",:username_session_key => "login",:extra_attributes_session_key => :login_extra_attributes,:enable_single_sign_out => true,:authenticate_on_every_request => false)
#CASClient::Frameworks::Rails::Filter.configure(
#  :cas_base_url => "http://iphelper.cdu.edu.cn/sso",
#  :username_session_key => :login,
#  :extra_attributes_session_key => :login_extra_attributes,
#  :enable_single_sign_out => true,
#  :authenticate_on_every_request => false
#)
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://iphelper.cdu.edu.cn/sso",
# :cas_base_url => "http://sso.zhiyisoft.com/",
  :username_session_key => :login,
  :extra_attributes_session_key => :cas_extra_attributes,
  :enable_single_sign_out => true,
  :authenticate_on_every_request => false
)




