# -*- coding: utf-8 -*-
# Simple Web Service using access_oracle 
require 'sinatra'
require 'json'
require "#{File.dirname(__FILE__)}/access_oracle"

$ACCESSOR = OrgStru.new

get '/' do
  'Web Service!'
end


get '/attend/tree/:user_id' do
  user_id  = params[:user_id]
  stru_tree = $ACCESSOR.user_dept_tree user_id
  tree_map = $ACCESSOR.produce_tree_to_map stru_tree
  JSON.dump tree_map 
end

get '/dept/users/:dept_id' do
  dept_id = params[:dept_id]
  JSON.dump $ACCESSOR.dept_users dept_id
end 

get '/dept/users_with_subdept/:dept_id' do
  dept_id = params[:dept_id]
  JSON.dump $ACCESSOR.dept_users_with_subdept dept_id
end 

get '/dept/users1/:dept_id' do
  dept_id = params[:dept_id]
  JSON.dump $ACCESSOR.dept_users_with_attr dept_id
end 


get '/dept/' do
  JSON.dump $ACCESSOR.dept_list
end 


get '/dept/id/:dept_id' do
  JSON.dump $ACCESSOR.dept_attr params[:dept_id]
end 

get '/user/id/:user_id' do
  JSON.dump $ACCESSOR.user_attr_ext params[:user_id]
end 

# get '/user/ext/id/:user_id' do
#   JSON.dump $ACCESSOR.user_attr_ext params[:user_id]
# end

get '/dept_tree/?' do
  tree_map = $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree) 
  JSON.dump tree_map 
end

get '/dept_tree/:dept_id' do
  tree_map = $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree(params[:dept_id])) 
  JSON.dump tree_map 
end

get '/dept_tree1/' do
  JSON.dump $ACCESSOR.dept_tree
end

get '/post/' do
  JSON.dump $ACCESSOR.post_map
end

get '/user/posts/:user_id' do
  JSON.dump $ACCESSOR.user_posts params[:user_id]
end

get '/checkers/?' do
  JSON.dump $ACCESSOR.checkers
end
