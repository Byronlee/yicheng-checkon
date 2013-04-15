# -*- coding: utf-8 -*-
module RegistrarRole
  def attend_depts  #返回一个文员的考勤树
    Webservice.get_data("attend/tree/"+staffid)
  end

  def dept_ids
    attend_depts['children'].map{ |x| x['id']}
  end

  def trainee_tasks
    tasks = Trainee.belong(self).map do |trainee|
       trainee.trainee_records.trainees
    end
    # [].first = nil
    tasks.blank? ? [] : tasks.first.decorate
  end
end
