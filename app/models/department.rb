class Department

  attr_accessor :number , :name , :id 

  def initialize id
    @number= ws_dept(id)["SD_DEPT_CODE"]
    @name= ws_dept(id)["SD_DEPT_NAME"]
    @id = id
  end

  def sub_dept
     
  end

  def users
    ws_users.map do |user|
      User.resource(user["SU_USER_ID"])
    end
  end

  def ws_users
    Webservice.get_data("dept/users1/"+id)
  end

  def ws_dept id
    Webservice.get_data("dept/id/"+id)
  end

  def users_with_priod_checkins time
    users.each do |user|
      record = StaffRecord.get_record user.staffid,time
      user.instance_variable_set(:@cins,record.checkins)
    end
  end
end
