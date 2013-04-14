class NoticeCell < Cell::Rails

  helper ApplicationHelper	

  def operate args
    @notice = args[:notice]
    if args[:current_user].registrar?
      render view: :view
    elsif args[:urrent_user].approval?
      render view: :form
    end
  end
end
