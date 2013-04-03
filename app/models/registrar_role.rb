module RegistrarRole
  def attend_depts
    Webservice.get_data("attend/tree/"+staffid)
  end
end
