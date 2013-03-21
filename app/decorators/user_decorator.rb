class UserDecorator < Draper::Decorator
  delegate_all


  def dept_name
    Department.new(source.dept_id).name
  end

  def user_no
     User.resource(source.staffid).user_no
  end

end
