# -*- coding: utf-8 -*-
module WsObject
    
  def self.create_obj (hash)
    hash.each do |k,v|
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

  def depts_node
   attend_depts["children"].map{|v| [v["name"] , v["id"]]}
  end

  def post
    position.any? ?  position.inject(""){|str,ps| str+ps[1]+"" } : "——"
  end
end
