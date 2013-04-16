class TraineeRecordDecorator < Draper::Decorator
 delegate_all

  def user
    user = source.trainee
    dept = Department.new(user.dept_id)
    {username: user.username,dept_name: dept.name,user_id: user.id}
  end

  def date
    source.created_date
  end
end
