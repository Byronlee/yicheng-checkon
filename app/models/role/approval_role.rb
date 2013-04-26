# -*- coding: utf-8 -*-
module ApprovalRole

  def attend_depts   #只读“成都伊城”的部门结构
    Webservice.get_data('dept_tree/' << Settings.approval_dept_id)
  end

  def counts_result behave_id , page
    Count.by_behave_id(behave_id).paginate(:page => page, :per_page => Settings.per_page)
  end
end
