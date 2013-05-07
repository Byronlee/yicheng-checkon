# -*- coding: utf-8 -*-
require File.expand_path('../application', __FILE__)

require 'casclient'
require 'casclient/frameworks/rails/filter'

Attendance::Application.initialize!

$ACCESSOR = OrgStru.new(Settings.yc_org_stru,Rails.configuration.logger)
$PERSSION = TempRegistratorLimitation.new(Settings.yc_org_stru,Rails.configuration.logger)

cas_logger = CASClient::Logger.new("#{Rails.root}/log/cas.log")
cas_logger.level = Logger::DEBUG
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => Settings.cas_url,
  :username_session_key => :login,
  :extra_attributes_session_key => :cas_extra_attributes,
  :enable_single_sign_out => true,
  :logger => cas_logger,
  :authenticate_on_every_request => false
)
