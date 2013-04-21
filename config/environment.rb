# -*- coding: utf-8 -*-
require File.expand_path('../application', __FILE__)

require 'casclient'
require 'casclient/frameworks/rails/filter'

#cas_logger = CASClient::Logger.new('/home/simlegate/workspace/yicheng-checkon/log/cas.log')
#cas_logger.level = Logger::DEBUG

Attendance::Application.initialize!

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => Settings.cas_url,
  :username_session_key => :login,
  :extra_attributes_session_key => :cas_extra_attributes,
  :enable_single_sign_out => true,
# :logger => cas_logger,
  :authenticate_on_every_request => false
)
