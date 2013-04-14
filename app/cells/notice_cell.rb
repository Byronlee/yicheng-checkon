class NoticeCell < Cell::Rails

  def operate args
    @notice = args[:notice]
    @current_user = args[:current_user]
    if args[:current_user].registrar?
      render view: :view
    elsif args[:current_user].approval?
      render view: :form
    end
  end
end
