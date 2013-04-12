# -*- coding: utf-8 -*-
class User
  include Mongoid::Document

  field :username
  field :user_no
  field :nickname_code
  field :nickname_display
  field :phone_num
  field :dept_id
  field :staffid
  field :dept_name
  field :dept_ancestors ,type:Array
  field :position , type:Array
  field :role , type:Array

  cattr_accessor :current_user

  attr_accessor :roles

  after_initialize do |user|
    if user.role
      role.each do |r|
        # bug array
        user.roles = Object.const_get(r+"Role").new(user)
      end
    end
  end

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
      position: rs["POSTS"],
      role: rs["role"]
    }
    new(attrs)
  end

  def ancestors
    2.times{ dept_ancestors.delete_at(0)}
    dept_ancestors.inject(""){|str,ps| str+ps[1]+"/"}+dept_name
  end

  def registrar?
    role.include? "Registrar"
  end

  def approval?
    role.include? "Approval"
  end

  def post
    position.any? ?  position.inject(""){|str,ps| str+ps[1]+"" } : "——"
  end
end
