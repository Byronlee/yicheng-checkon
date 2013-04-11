require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  #require 'mongoid'
  #ENV["MONGOID_ENV"] = "test"
  #Mongoid.load!(File.expand_path("config/mongoid.yml",  __FILE__))

  require File.expand_path("../../config/environment.rb",  __FILE__)

  require 'rspec/rails'
  require "factory_girl_rails"
  require "database_cleaner"
  require "simplecov"

  ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')
  Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }


  RSpec.configure do |config|

    config.mock_with :rspec
    config.include FactoryGirl::Syntax::Methods
    config.include Mongoid::Matchers

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end


Spork.each_run do
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each {|f| load f}
  FactoryGirl.reload
  SimpleCov.start
end


def login 
  CASClient::Frameworks::Rails::Filter.fake("admin",{:user => "wo"})
end
