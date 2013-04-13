# -*- coding: utf-8 -*-
class Notice
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Content

  field :launcher ,type:String
  field :receiver ,type:String
  field :content,type: String
  field :state,type: Boolean,default: false
  field :remark, type:String  

  belongs_to :modify

  default_scope where(state: false) 

  class << self

    def registrar
      where(receiver: User.current_user.staffid)
    end

    def approval
      where(receiver: "approval")
    end
  end
  
  def read 
    update_attribute(:state, true)
  end

end

