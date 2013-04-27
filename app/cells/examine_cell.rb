class ExamineCell < Cell::Rails  

  def update_examine args
    @examine = args[:examine]
    @current_user = args[:current_user]
    return  if @current_user.approval?
    @examine.blank? ? (render view: :registrar_unfinishe):(render view: :registrar_finished )
  end
  
end
