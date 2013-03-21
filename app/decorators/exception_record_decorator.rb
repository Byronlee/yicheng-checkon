class ExceptionRecordDecorator < Draper::Decorator
  delegate_all

  def user
    user = source.user
    dept = Department.new(user.dept_id)
    {name: user.username,dept_name: dept.name,user_id: user.id}
  end

  def date
    source.created_at.to_date
  end
   
end
