# -*- coding: utf-8 -*-
class User
  include Mongoid::WsObject

  attr_accessor :roles

  def perssion roles_array
    self.roles = roles_array
    roles_array.each do |r|
      extend Object.const_get(r + 'Role')
    end
    # roles = roles_array why?    
    self
  end

  def initialize uid 
    user  = $ACCESSOR.user_attr uid
    user_ext = $ACCESSOR.user_attr_ext user
    @data = user.merge(user_ext)
  end

  def self.resource sid
    new(sid) 
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

  def rightsman?
    roles.include? "Rightsman"
  end

  def depts_node
   attend_depts[:children].map{|v| [v[:name] , v[:id]]}
  end

  def post
    position.any? ?  position.inject(""){|str,ps| str+ps[1]+"" } : "——"
  end
end
