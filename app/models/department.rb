class Department

  attr_accessor :number , :name , :id 

  def initialize id
    infor = $ACCESSOR.dept_attr(id)
    @number= infor["SD_DEPT_CODE"]
    @name  = infor["SD_DEPT_NAME"]
    @id = id
  end

  def users
    $ACCESSOR.dept_users(id).map do |user_id|
      User.resource(user_id)
    end
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
