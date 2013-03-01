# -*- coding: utf-8 -*-
class User

  attr_accessor :nickname_code , :nickname_display , :phone_num , :username ,  :user_no , :dept_id , :id

  def  initialize id 
    resource= Webservice.get_data "/user/id/"+id
    @nickname_code= resource["SU_NICKNAME_CODE"]
    @nickname_display= resource["SU_NICKNAME_DISPLAY"]
    @phone_num= resource["SU_PHONE_NUM"]
    @username= resource["SU_USERNAME"]
    @user_no= resource["SU_USER_NO"]
    @dept_id= resource["SU_DEPT_ID"]
    @id = id
  end


 def attend_depts
   Webservice.get_data("/attend/tree/"+@id)
 end
end
