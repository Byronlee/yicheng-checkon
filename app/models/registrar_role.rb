# -*- coding: utf-8 -*-
class RegistrarRole

  def initialize user
    @user = user
  end

  def attend_depts  #返回一个文员的考勤树
    Webservice.get_data("attend/tree/"+@user.staffid)
  end
end
