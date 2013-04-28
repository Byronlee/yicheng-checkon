class ExamineCell < Cell::Rails  
  
  def update_examine args
    @examine = args[:examine]
    @current_user = args[:current_user]
    return  if @current_user.approval?
    if examine_proces_registrar_state(@current_user ,@examine)      
      render view: :registrar_finished
    else
      render view: :update_examine
    end
  end
  
  def examine_proces_registrar args
    state = examine_proces_registrar_state(args[:current_user],args[:examine])
    state ? (render view: :registrar_finished) :  (render view: :registrar_unfinish)
  end
  

  def examine_proces_registrar_state cu,e
    registrars = $ACCESSOR.users_with_role(:registrar,cu.dept_id)
    cu_proces = e.proces.in(:registrar => registrars).map(&:state)
    cu_proces.all?  ? true : false
  end

end
