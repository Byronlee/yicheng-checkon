# -*- coding: utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)
require 'casclient'
require 'casclient/frameworks/rails/filter'
# Initialize the rails application
# Attendance::Application.initialize!
# enable detailed CAS logging
#cas_logger = CASClient::Logger.new(::Rails.root+'/log/cas.log')
#cas_logger.level = Logger::DEBUG

#Slim::Engine.set_default_options :shortcut => {'&' => {:tag => 'a', :attr => 'href'}, '#' => {:attr => 'id'}, '.' => {:attr => 'class'}}

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://61.139.87.55:7890/",
  :login_url    => "http://61.139.87.55:7890/login",
  :logout_url   => "http://61.139.87.55:7890/logout",
  :username_session_key => :login,
  :extra_attributes_session_key => :cas_extra_attributes,
  :enable_single_sign_out => true,
  :authenticate_on_every_request => false
)

Attendance::Application.initialize!


