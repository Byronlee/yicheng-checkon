# -*- coding: utf-8 -*-
module ApprovalRole

  def attend_depts   #只读“成都伊城”的部门结构
    return @depts if @depts
    @depts = $ACCESSOR.dept_tree(Settings.approval_dept_id)
  end

  def users_with_subdept
    []
  end
end
