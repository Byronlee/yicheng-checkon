class NoticeCell < Cell::Rails

  def operate args
    @notice = args[:notice]
    if User.current_user.registrar?
      render view: :view
    elsif User.current_user.approval?
      render view: :form
    end
  end
end
