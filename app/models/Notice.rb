# -*- coding: utf-8 -*-
class Notice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :launcher ,type:String
  field :receiver ,type:String
  field :content  ,type:String
  field :state    ,type:Boolean ,default:  false

  field :

  default_scope where(state: false) 
  has_one :resource



  after_create do |notice|
    notice.resource.create(data: data)
  end


  def create params
    create params
  end



end

