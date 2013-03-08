class Department

  attr_accessor :number , :name , :id 

  def initialize id
    @id = id
    @number= resource["SD_DEPT_CODE"]
    @name= resource["SD_DEPT_NAME"]
  end

  def resource
    Webservice.get_data("dept/id/"+id)
  end

  def user_ids 
    Webservice.get_data("dept/users/"+id)
  end
  def user_hashs
    Webservice.get_data("dept/users1/"+id)
  end

  def users
    user_hashs.inject([]){|arry,user_id| arry << User.new(user_id)}
  end
end
