class MessageCell < Cell::Rails

  def operate args
    @message = args[:message]
    if User.current_user.registrar?
      render view: :form
    elsif User.current_user.approval?
      render view: :read
    end
  end
end
