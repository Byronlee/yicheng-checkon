# -*- coding: utf-8 -*-
class User
<<<<<<< HEAD
=======
  include Mongoid::WsObject
>>>>>>> 19eb06dbddbbca672edbd7d2e9780baf662afefc

  attr_accessor :roles

  def perssion roles_array
    self.roles = roles_array
    roles_array.each do |r|
      class_eval{ include Object.const_get(r + 'Role')}
    end
    # roles = roles_array why?    
    self
  end

<<<<<<< HEAD
  def self.resource user_id
    attrs = Webservice.get_data("/user/id/"+user_id)
    hash = attrs.each do |k ,v |
      {Settings.user_attrs[k] =>  v}
    end
    OpenStruct.new(hash)
=======
  def initialize id  # todo 何老师 在user_no 前加0
    @data = Webservice.get_data("/user/id/"+id)
  end

  def self.resource sid
    new(sid) 
  end

  def dept_name
     Department.new(dept_id).name 
>>>>>>> 19eb06dbddbbca672edbd7d2e9780baf662afefc
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
