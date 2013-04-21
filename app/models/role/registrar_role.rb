# -*- coding: utf-8 -*-
module RegistrarRole
  def attend_depts  #返回一个文员的考勤树
    Webservice.get_data("attend/tree/"+staffid)
  end

  def dept_ids
    attend_depts['children'].map{ |x| x['id']}
  end

  def trainee_tasks
    Trainee.belong(self).map{|trainee|trainee.trainee_records.trainees}.flatten
  end

  def users_with_subdept
    Webservice.get_data("dept/users_with_subdept/"+dept_id)
  end
end
