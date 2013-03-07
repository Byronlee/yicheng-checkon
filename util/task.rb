# -*- coding: utf-8 -*-
#!/usr/bin/env ruby
#require 'rails'
require 'rubygems'  # not necessary for Ruby 1.9
require 'mongo'
require 'patron'
require 'json'

include Mongo

class Tasks

  module Webservice
    @sess = Patron::Session.new
    @sess.base_url = "http://project.zhiyisoft.com:4567/"
    def self.get_data str
      response = @sess.get str
      JSON.parse(response.body)
    end
  end

  def initialize_everyday_recods

    @client = MongoClient.new('localhost', 27017, :pool_size => 5 )
    @db     = @client['attendance_development']
    @coll_records   = @db['records']
    @coll_checkunit = @db['check_units']  
    @coll_behaves   = @db['behaves']  
#    @default_behave_id = @coll_behaves.find({:default => true})
#    p @default_behave_id
    @attend_tree =Tasks:: Webservice.get_data "attend/tree/4028809b3c6fbaa7013c6fbc3db41bc3"
  
    @attend_tree["children"].map do | dept | 
      Tasks::Webservice.get_data("dept/users/"+dept["id"]).map do | user |
        
        checkins =  @coll_checkunit.find().map do |unit|
          { :check_unit_id => unit["id"], 
            :behave_id => ""
          }
          end

          @coll_records.insert({ :staffid => user, 
                                 :attend_date => Time.now ,
                                 :record_person => "" ,
                                 :record_zone =>"" , 
                                 :create_at => Time.now ,
                                 :checkins => checkins
                               })
      end


      
    end
  

    puts "There are #{@coll_records.count} records. Here they are:"
  end
end

  Tasks.new.initialize_everyday_recods
