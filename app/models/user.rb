# -*- coding: utf-8 -*-
class User
  attr_accessor :nickname_code , :nickname_display , :phone_num , :username ,  :user_no , :dept_id , :id , :dept_name

  def initialize id
    if id.class == String 
      resource= Webservice.get_data "/user/id/"+id
      @id = id
    else
      @id = id["SU_USER_ID"]
      resource = id
    end
    

    @nickname_code= resource["SU_NICKNAME_CODE"]
    @nickname_display= resource["SU_NICKNAME_DISPLAY"]
    @phone_num= resource["SU_PHONE_NUM"]
    @username= resource["SU_USERNAME"]
    @user_no= resource["SU_USER_NO"]
    @dept_id= resource["SU_DEPT_ID"]
    @dept_name= Department.new(resource["SU_DEPT_ID"]).name

  end

  def attend_depts
    Webservice.get_data("/attend/tree/"+@id)
  end
end
