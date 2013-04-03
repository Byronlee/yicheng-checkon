module ApprovalRole
  def attend_depts
    Webservice.get_data("dept_tree/4028809b3c6fbaa7013c6fbc39510002")
  end
end
