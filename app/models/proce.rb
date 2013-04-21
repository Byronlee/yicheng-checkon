# -*- coding: utf-8 -*-
class Proce
  include Mongoid::Document

  field :registrar_id,type:String
  field :state, type:Boolean, default: false

  belongs_to :examine
end
