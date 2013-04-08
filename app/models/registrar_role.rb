# -*- coding: utf-8 -*-
class RegistrarRole
  def attend_depts  #返回一个文员的考勤树
    Webservice.get_data("attend/tree/"+User.current_user.staffid)
  end
end
