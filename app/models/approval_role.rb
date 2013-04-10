# -*- coding: utf-8 -*-
class ApprovalRole

  def initialize user
    @user = user
  end

  def attend_depts   #只读“成都伊城”的部门结构
    Webservice.get_data("dept_tree/4028809b3c6fbaa7013c6fbc39510002")
  end
end
