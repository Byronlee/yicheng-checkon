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
  # modify_applied, modify_approved, modify_direct
  # examine_applied, exception_leave,unfinished_attend

  belongs_to :modify
  belongs_to :notice_type
  belongs_to :examine

  class << self

    def registrar  current_user
      where(receiver: current_user.staffid).today_or_unread 
    end

    def approval
      where(receiver: "approval").today_or_unread 
    end

    def today_or_unread
      self.or({state: false} ,{:updated_at.gte => Date.today.beginning_of_day,:updated_at.lte => Date.today.end_of_day}).asc(:state)
    end

  end
  
  def read 
    update_attribute(:state, true)
  end
end

