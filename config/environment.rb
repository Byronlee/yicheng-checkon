# Load the rails application
require File.expand_path('../application', __FILE__)
require 'casclient'
require 'casclient/frameworks/rails/filter'
# Initialize the rails application
Attendance::Application.initialize!
# enable detailed CAS logging
# cas_logger = CASClient::Logger.new(::Rails.root+'/log/cas.log')
# cas_logger.level = Logger::DEBUG

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://iphelper.cdu.edu.cn/sso"
)
