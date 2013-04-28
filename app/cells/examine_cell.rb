class ExamineCell < Cell::Rails  

  def update_examine args
    @examine = args[:examine]
    @current_user = args[:current_user]
    return  if @current_user.approval?
    return (render view: :registrar_unfinishe) if @examine.underway?
    return (render view: :registrar_finished ) if @examine.finished?
  end
  
end
