# -*- coding: utf-8 -*-
class Notice
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Content

  field :launcher ,type:String
  field :receiver ,type:String
  field :content,type: String
  field :state,type: Boolean,default: false
  field :remark, type:String  

  belongs_to :modify
  belongs_to :examine



  class << self

    def registrar  current_user
      where(receiver: current_user.staffid).or({state: false} ,{state: true ,"updated_at.gt" => Date.today.beginning_of_day,"updated_at.lt" => Date.today.end_of_day})    # 留意看看是否有重复数据
    end

    def approval
      where(receiver: "approval").or({state: false} ,{state: true ,"updated_at.gt" => Date.today.beginning_of_day,"updated_at.lt" => Date.today.end_of_day})
    end

  end
  
  def read 
    update_attribute(:state, true)
  end
end

