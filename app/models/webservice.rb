# -*- coding: utf-8 -*-
require 'org_stru'

class Webservice

 # refactor OOP
 @sess = Patron::Session.new
 @sess.base_url = Settings.ws_url

 @org_object = OrgStru.new

 def self.user_by_id id
   user  = @org_object.user_attr id
   return {} if user.nil?
   user_ext = @org_object.user_attr_ext user
   return user.merge user_ext
 end

 def self.dept_users_by_id id
   @org_object.dept_users_with_attr id
 end

 def self.dept_by_id id
   @org_object.dept_attr id
 end


 def self.attend_tree registrar_id
   @org_object.attend_tree registrar_id
 end
 









 def self.get_data str
    response = @sess.get str
    JSON.parse(response.body)
 end

 def self.dpt_users str
   @users =[];
   (Webservice.get_data str).each{|x| @users << ((Webservice.get_data "user/id/"+x).merge({"SU_USER_ID"=> x})) }
   @users
 end

 def self.users_with_subdept dept_id    # 用户组[]
  Webservice.get_data("dept/users_with_subdept/#{dept_id}")
 end

 def self.get_registrars
    Webservice.get_data "/registrars"
 end


 def self.search_users keyword
   get_data(URI.escape("search/users/"+ keyword))
 end

end
