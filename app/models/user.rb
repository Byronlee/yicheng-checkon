# -*- coding: utf-8 -*-
class User
  include Mongoid::WsObject

  attr_accessor :roles

  def perssion roles_array
    self.roles = roles_array
    roles_array.each do |r|
      class_eval{ include Object.const_get(r + 'Role')}
    end
    # roles = roles_array why?    
    self
  end

  def initialize id  # todo 何老师 在user_no 前加0
    @data = Webservice.get_data("/user/id/"+id)
  end

  def self.resource sid
    new(sid) 
  end

  def dept_name
     Department.new(dept_id).name 
  end

  def ancestors
    2.times{ dept_ancestors.delete_at(0)}
    dept_ancestors.inject(""){|str,ps| str+ps[1]+"/"}+dept_name
  end

  def registrar?
    roles.include? "Registrar"
  end

  def approval?
    roles.include? "Approval"
  end

  def depts_node
   attend_depts["children"].map{|v| [v["name"] , v["id"]]}
  end

  def post
    position.any? ?  position.inject(""){|str,ps| str+ps[1]+"" } : "——"
  end
end
