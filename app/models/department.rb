class Department

  attr_accessor :number , :name , :id 

  def initialize id
    resource = Webservice.get_data("dept/id/"+id)
    @number= resource["SD_DEPT_CODE"]
    @name= resource["SD_DEPT_NAME"]
    @id = id
  end

  def users_ids 
    Webservice.get_data("dept/users/"+@id)
  end

  def users_with_infor
    Webservice.get_data("dept/users1/"+@id)
  end

  def users
    users_with_infor.inject([]){|arry,user_id| arry << User.new(user_id)}
  end

  def users_with_priod_checkins time
    users.each do |user|
      behaves = Record.get_record user.id,time
      user.instance_variable_set(:@behaves,behaves.checkins)
    end
  end
end
