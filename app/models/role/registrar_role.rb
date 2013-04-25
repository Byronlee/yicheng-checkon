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

  def counts_result behave_id, page
    Count.by_behave_id(behave_id).in("_id.user_id" => users_with_subdept).paginate(:page => page, :per_page => Settings.per_page)
  end

end






