# -*- coding: utf-8 -*-
module ApprovalRole

  def attend_depts   #只读“成都伊城”的部门结构
    tree = $ACCESSOR.dept_tree(Settings.approval_dept_id)
    $ACCESSOR.produce_tree_to_map tree
  end

  def users_with_subdept
    []
  end
end
