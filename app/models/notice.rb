# -*- coding: utf-8 -*-
class Notice
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Content

  field :launcher ,type:String
  field :receiver ,type:String
  field :content,type: String
  field :state,type: Boolean,default: false

  belongs_to :modify

  default_scope where(state: false) 
end

