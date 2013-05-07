class NoticeCell < Cell::Rails
  helper NoticesHelper

  def operate args
    @notice = args[:notice]
    @current_user = args[:current_user]     
    case @notice.notice_type.name
    when "modify_applied"
      return  render view: :form_approval
    when "modify_approved"
      return  render view: :approval_decision
    when "examine_applied"
      return  render view: :examine_notice
    else
      return  render view: :only_read
    end
  end
end
