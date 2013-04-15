# -*- coding: utf-8 -*-
class Task

 def self.staffs current_user
   StaffRecord.staffs current_user
 end


 def self.trainees
   # TODO 应该返回 当前文员所在区的 无工号员工
   TraineeRecord.trainees.decorate
 end
end
