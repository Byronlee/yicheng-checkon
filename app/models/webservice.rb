class Webservice

 @sess = Patron::Session.new
 @sess.base_url = "http://localhost:4567/"


 def self.getDate str
    response = @sess.get str
    JSON.parse(response.body)
 end

 def self.dpt_users str
   @users =[];
   (Webservice.getDate str).each{|x| @users << (Webservice.getDate "user/id/"+x) }
   @users
 end


end
