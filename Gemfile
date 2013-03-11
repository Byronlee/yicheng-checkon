source 'http://ruby.taobao.org'

ruby '1.9.3'
gem 'rails'

group :test do
  gem 'turn', :require => false
  gem 'rspec-rails'
  gem 'spork'
  gem 'database_cleaner'
  gem 'factory_girl_rails', :require => false
  gem "capybara"
  gem "launchy"
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'rb-fsevent'
  gem 'simplecov', :require => false
end

group :development do
  gem "debugger"
end

HOST_OS = RbConfig::CONFIG['host_os']
case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group =>:development
    gem 'growl', :group =>:development
  when /linux/i
    gem 'libnotify', :group =>:development
    gem 'rb-inotify', :group =>:development
  when /mswin|windows/i
    gem 'rb-fchange', :group =>:development
    gem 'win32console', :group =>:development
    gem 'rb-notifu', :group =>:development
end
gem 'mongo'
gem 'whenever'
gem "mongoid", "~> 3.1.2"
gem "bson_ext"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

gem "twitter-bootstrap-rails"
gem 'asf-soap-adapter', :require =>'activerecord-activesalesforce-adapter'

gem "patron"
gem "rubycas-client", "2.3.9"
gem 'jquery-rails',"2.1.4"
gem 'slim',"1.3.6"
gem 'slim-rails',"1.1.0"
gem 'rocket_pants', '1.6.1'
gem 'ruote'
gem 'ruote-mon'
gem 'state_machine'
gem 'cancan'
