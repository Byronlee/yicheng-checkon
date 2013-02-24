class Webservice

 @sess = Patron::Session.new
 @sess.base_url = "http://localhost:4567/"


 def self.getData str
    response = @sess.get str
    JSON.parse(response.body)
 end

 def self.dpt_users str
   @users =[];
   (Webservice.getData str).each{|x| @users << ((Webservice.getData "user/id/"+x).merge({"SU_USER_ID"=> x})) }
   @users
 end


end
