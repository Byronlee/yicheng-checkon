# -*- coding: utf-8 -*-
class Notice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :launcher ,type:String
  field :receiver ,type:String
  field :state    ,type:Boolean ,default:  false

  field :data

  default_scope where(state: false) 

  def launch?
    return true if data[:record_id]
    record = StaffRecord.find(data[:record_id])
    record.change? data[:checkins]
  end
end

