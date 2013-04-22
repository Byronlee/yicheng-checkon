class CountCell < Cell::Rails  
  helper CountsHelper

  def update_examine args
    args[:state].blank? ? (render view: :registrar_unfinishe):(render view: :registrar_finished )
  end
  
end
