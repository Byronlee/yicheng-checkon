class NoticeCell < Cell::Rails
  helper NoticesHelper

  def operate args
    @notice = args[:notice]
    @current_user = args[:current_user]     
    case @notice.notice_type
    when "modify_applied"
      render view: :form_approval
    when "modify_approved"
      render view: :approval_decision
    when "examine_applied"
      render view: :examine_notice
    else
      render view: "only_read"
    end
  end
end
