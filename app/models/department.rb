class Department

  attr_accessor :number , :name , :id , :count

   def initialize id
     resource = Webservice.getData("/dept/id/"+id)
     @number= resource["SD_DEPT_CODE"]
     @name= resource["SD_DEPT_NAME"]
     @id = id
   end


  def users 
    (Webservice.getData("/dept/users/"+@id)).inject([]){|arry,user_id| arry << User.new(user_id)}
  end
end
