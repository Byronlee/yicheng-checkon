class TraineeDecorator < Draper::Decorator
  delegate_all

  def dept_name
    Department.new(source.dept_id).name
  end

  def user_number
     User.resource(source.staffid).user_no
  end
end
