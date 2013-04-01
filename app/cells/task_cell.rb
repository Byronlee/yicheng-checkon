class TaskCell < Cell::Rails
  helper StaffRecordsHelper , ApplicationHelper

  def color args 
    @dept_name = args[:dept_name]
    args[:state].eql?("registered") ? (render view: :green) : (render view: :red)
  end


  def onekey args
    @task = args[:task]
    args[:task][:state].eql?("checking") ? (render view: :onekey) : (render view: :registered)
  end



  

end
