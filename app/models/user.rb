# -*- coding: utf-8 -*-
class User
  include Mongoid::Document
  field :salary_time ,type: String , default: Time.now.to_date
  field :user_no ,type: String, default: "000000"
  field :username ,type: String

  field :nickname_code 
  field :nickname_display 
  field :phone_num 
  field :dept_id 
  field :staffid
  field :dept_name

  has_many :exception_records
# validates_presence_of :username , :salary_time , :dept_id
# validates_uniqueness_of :username

  def self.resource id
    if id.class == String 
      init_attr Webservice.get_data("/user/id/"+id),id
    else
      init_attr id
    end
  end

  def self.init_attr rs,id
    attrs = {
      staffid: id || rs["SU_USER_ID"],
      nickname_code: rs["SU_NICKNAME_CODE"],
      nickname_display: rs["SU_NICKNAME_DISPLAY"],
      phone_num: rs["SU_PHONE_NUM"],
      username: rs["SU_USERNAME"],
      user_no: rs["SU_USER_NO"],
      dept_id: rs["SU_DEPT_ID"],
      dept_name: Department.new(rs["SU_DEPT_ID"]).name
    }
    new(attrs)
  end

  def attend_depts
    Webservice.get_data("/attend/tree/"+staffid)
  end

  def initialized_days
    (Date.today - Date.parse(salary_time)).to_i + 1
  end
end
