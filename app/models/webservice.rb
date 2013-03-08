class Webservice

 @sess = Patron::Session.new
 @sess.base_url = "http://proj.cdu.edu.cn:4567/"

 def self.get_data str
    response = @sess.get str
    JSON.parse(response.body)
 end

 def self.dpt_users str
   @users =[];
   (Webservice.get_data str).each{|x| @users << ((Webservice.get_data "user/id/"+x).merge({"SU_USER_ID"=> x})) }
   @users
 end


end
