# -*- coding: utf-8 -*-
class User
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  field :salary_time ,type: String 
  field :user_no ,type: String, default: "000000"
  field :username ,type: String
  field :is_first ,type: Boolean, default: true

  field :nickname_code 
  field :nickname_display 
  field :phone_num 
  field :dept_id 
  field :staffid
  field :dept_name
  field :dept_ancestors ,type:Array
  field :position , type:Array


  has_many :exception_records
  validates_presence_of :username , :salary_time , :dept_id
  validates_uniqueness_of :username

  def self.resource sid
    if sid.instance_of?(String)
      init_attr Webservice.get_data("/user/id/"+sid),sid
    else
      init_attr sid
    end
  end

  def self.init_attr rs,sid=nil
    attrs = {
      staffid: sid || rs["SU_USER_ID"],
      nickname_code: rs["SU_NICKNAME_CODE"],
      nickname_display: rs["SU_NICKNAME_DISPLAY"],
      phone_num: rs["SU_PHONE_NUM"],
      username: rs["SU_USERNAME"],
      user_no: rs["SU_USER_NO"],
      dept_id: rs["SU_DEPT_ID"],
      dept_name: Department.new(rs["SU_DEPT_ID"]).name ,
      dept_ancestors: rs["DEPT_ANCESTORS"],
      position: rs["POSTS"]

    }
    new(attrs)
  end

  def attend_depts
    Webservice.get_data("/attend/tree/"+staffid)
  end


  def ancestors
    2.times{dept_ancestors.delete_at(0)}
    dept_ancestors.inject(""){|str,ps| str+ps[1]+"/"}+dept_name
  end

  def post
    position.any? ?  position.inject(""){|str,ps| str+ps[1]+"" } : "——"
  end


  def initialized_days
    (Date.today - Date.parse(salary_time)).to_i + 1
  end

  def not_first
    update_attribute(:is_first, false)
  end
end
