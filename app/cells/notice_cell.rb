class NoticeCell < Cell::Rails
  helper NoticesHelper

  def operate args
    @notice = args[:notice]
    @current_user = args[:current_user] 
    return (render view: :form_approval) if args[:current_user].approval?
    return (render view: :approval_decision) unless @notice.modify_id.blank?
    return (render view: :examine_notice) unless @notice.examine_id.blank?
  end
end
