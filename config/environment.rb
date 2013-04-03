# -*- coding: utf-8 -*-

require File.expand_path('../application', __FILE__)

require 'casclient'
require 'casclient/frameworks/rails/filter'

cas_logger = CASClient::Logger.new('/home/simlegate/workspace/yicheng-checkon/log/cas.log')
cas_logger.level = Logger::DEBUG

:authenticate_on_every_request

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://61.139.87.55:7890/",
  :username_session_key => :login,
  :extra_attributes_session_key => :cas_extra_attributes,
  :enable_single_sign_out => true,
  :logger => cas_logger,
  :authenticate_on_every_request => false
)

Attendance::Application.initialize!


