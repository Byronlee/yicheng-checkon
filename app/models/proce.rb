# -*- coding: utf-8 -*-
class Proce
  include Mongoid::Document

  field :registrar,type:String
  field :state, type:Boolean, default: false

  belongs_to :examine

  def user
    User.resource(registrar)
  end

end
