module UsersHelper

 def ancestors staffid
   User.resource(staffid).ancestors
 end
 
 def position staffid
   User.resource(staffid).post
 end
end
