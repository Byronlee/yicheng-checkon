class MessageCell < Cell::Rails

  def operate args
    @message = args[:message]
    if User.current_user.registrar?
      render view: :view
    elsif User.current_user.approval?
      render view: :form
    end
  end
end
