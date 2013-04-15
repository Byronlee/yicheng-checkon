# -*- coding: utf-8 -*-
class User

  attr_accessor :roles

  def perssion roles_array
    roles_array.each do |r|
      class_eval{ include Object.const_get(r + 'Role')}
    end
    # roles = roles_array why?
    self.roles = roles_array
    self
  end

  def self.resource user_id
    attrs = Webservice.get_data("/user/id/"+user_id)
    hash = attrs.each do |k ,v |
      {Settings.user_attrs[k] =>  v}
    end
    OpenStruct.new(hash)
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
