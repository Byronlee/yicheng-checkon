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

RSpec::Matchers.define :have_ability do |ability_hash, options = {}|
    match do |user|
      ability         = Ability.new(user)
      target          = options[:for]
      @ability_result = {}
      ability_hash    = {ability_hash => true} if ability_hash.is_a? Symbol # e.g.: :create => {:create => true}
      ability_hash    = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array # e.g.: [:create, :read] => {:create=>true, :read=>true}
      ability_hash.each do |action, true_or_false|
        @ability_result[action] = ability.can?(action, target)
      end
      !ability_hash.diff(@ability_result).any?
    end

    failure_message_for_should do |user|
      ability_hash,options = expected
      ability_hash         = {ability_hash => true} if ability_hash.is_a? Symbol # e.g.: :create
      ability_hash         = ability_hash.inject({}){|_, i| _.merge({i=>true}) } if ability_hash.is_a? Array # e.g.: [:create, :read] => {:create=>true, :read=>true}
      target               = options[:for]
      message              = "expected User:#{user} to have ability:#{ability_hash} for #{target}, but actual result is #{@ability_result}"
    end

    #to clean up output of RSpec Documentation format
    description do 
      if ability_hash.length == 1
        "have ability #{expected.to_s.match(/(:[^ ]*)/)[1]} for #{expected.to_s.match(/<([^ ]*)/)[1]}"
      else
        "have abilities #{expected.to_s.match(/\[(\[[^\]]*\]),/)[1]} for #{expected.to_s.match(/<([^ ]*)/)[1]}"
      end
    end
  end

def registrar_login
  CASClient::Frameworks::Rails::Filter.fake('cangnan',{"attrs" => {"SU_USER_ID"=>"2",'roles'=> ['Registrar','Rightsman']}})
end

def approval_login
  CASClient::Frameworks::Rails::Filter.fake('cangnan',{'attrs' => {"SU_USER_ID" => "2",'roles'=> ['Approval']}})
end

def no_role_login 
  CASClient::Frameworks::Rails::Filter.fake('any',{'attrs' => {"SU_USER_ID" => "2",'roles'=> []}})
end
