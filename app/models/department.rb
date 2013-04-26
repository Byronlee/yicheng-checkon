class Department

  attr_accessor :number , :name , :id 

  def initialize id
    infor = ws_dept(id)
    @number= infor["SD_DEPT_CODE"]
    @name  = infor["SD_DEPT_NAME"]
    @id = id
  end

  def users
    ws_users.map do |user|
      User.resource(user["SU_USER_ID"])
    end
  end

  def ws_users
    Webservice.dept_users_by_id id
  end

  def ws_dept id
    Webservice.dept_by_id id
  end

  def users_select
    users.map do |u|
      [u.username,u.staffid]
    end
  end

  def users_with_priod_checkins time
    users.each do |user|
      record = StaffRecord.get_record user.staffid,time
      user.instance_variable_set(:@cins,record.checkins)
    end
  end
end
