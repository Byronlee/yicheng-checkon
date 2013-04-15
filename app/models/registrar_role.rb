# -*- coding: utf-8 -*-
module RegistrarRole
  def attend_depts  #返回一个文员的考勤树
    Webservice.get_data("attend/tree/"+staffid)
  end
end
