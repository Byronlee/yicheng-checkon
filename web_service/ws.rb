# -*- coding: utf-8 -*-
# Simple Web Service using access_oracle 
require 'sinatra'
require 'json'
require "#{File.dirname(__FILE__)}/org_stru"

$ACCESSOR = OrgStru.new

def check_id id
  id =~ /^[0-9a-f]+$/
end

get '/' do
  'Web Service!'
end

get '/input_error' do
  'Input Error!'
end


# get '/attend/tree/:user_id' do
#   user_id  = params[:user_id]
#   redirect "/input_error" unless check_id user_id 
#   JSON.dump $ACCESSOR.attend_tree user_id
# end

get '/dept/users/:dept_id' do
  dept_id = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  JSON.dump $ACCESSOR.dept_users dept_id
end 

get '/dept/users_with_subdept/:dept_id' do
  dept_id = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  JSON.dump $ACCESSOR.dept_users_with_subdept dept_id
end 

get '/dept/users1/:dept_id' do
  dept_id = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  JSON.dump $ACCESSOR.dept_users_with_attr dept_id
end 

get '/search/users/:keyword' do
  JSON.dump $ACCESSOR.search_user(params[:keyword]).map{|id| $ACCESSOR.user_attr id}
end

get '/dept/' do
  JSON.dump $ACCESSOR.dept_list
end 


get '/dept/id/:dept_id' do
  dept_id = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  JSON.dump $ACCESSOR.dept_attr dept_id
end 

get '/user/id/:user_id' do
  user_id  = params[:user_id]
  redirect "/input_error" unless check_id user_id   
  user = $ACCESSOR.user_attr user_id
  ext_attrs = $ACCESSOR.user_attr_ext user 
  JSON.dump (user.merge ext_attrs)
end 

# get '/user/ext/id/:user_id' do
#   JSON.dump $ACCESSOR.user_attr_ext params[:user_id]
# end

get '/dept_tree/?' do
  tree_map = $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree) 
  JSON.dump tree_map 
end

get '/dept_tree/:dept_id' do
  dept_id = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  tree_map = $ACCESSOR.produce_tree_to_map ($ACCESSOR.dept_tree dept_id) 
  JSON.dump tree_map 
end

get '/dept_tree1/' do
  JSON.dump $ACCESSOR.dept_tree
end

get '/post/' do
  JSON.dump $ACCESSOR.post_map
end

get '/user/posts/:user_id' do
  user_id  = params[:user_id]
  redirect "/input_error" unless check_id user_id 
  JSON.dump $ACCESSOR.user_posts user_id
end

get '/registrars/?' do
  JSON.dump $ACCESSOR.all_users_with_role :registrar
end

get '/registrars/:dept_id' do
  dept_id  = params[:dept_id]
  redirect "/input_error" unless check_id dept_id 
  JSON.dump $ACCESSOR.users_with_role :registrar,dept_id
end

get '/perssion/users/:user_id' do
  user_id  = params[:user_id]
  redirect "/input_error" unless check_id user_id 
  JSON.dump $ACCESSOR.temp_registrars user_id
end


post '/perssion/authorize/?' do
# method: post
# params:  {curent_user_id: id, users: [{user_id: xxxx, begin: xxx, end: xxxx}...]
# expect : true or false
  begin 
    JSON.parse(params[:users]).each do |user|
      next unless ["user_id","begin","end"].reduce(true){|r,key| r and (user.has_key? key)}
      next unless check_id user["user_id"] 
      $ACCESSOR.temp_registrar_rights_peroid(user["user_id"],
                                             :begin => Date.parse(user["begin"]),
                                             :end => Date.parse(user["user_id"]))
    end
    JSON.dump true

  rescue
    JSON.dump false
  end
end

