# -*- coding: utf-8 -*-
class Webservice

 @sess = Patron::Session.new
 @sess.base_url = Settings.ws_url

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

end
