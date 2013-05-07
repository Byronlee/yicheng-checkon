# -*- coding: utf-8 -*-
class Modify
  include Mongoid::Document

  field :checkins ,type:Hash
  field :decision , type: String
  field :exception, type: String #是否为上月或上月以前修改
   
  belongs_to :staff_record
  has_many :notices

  after_create do |modify|
    modify.staff_record.apply if defined?(modify.update_way)
  end
  

  after_update do |modify|
    modify.staff_record.approval
  end

  def save_with_change
    staff_record.change?(checkins) ? save : false
  end

  def handle data
     update_attributes(decision: data[:decision])
     update_attributes(exception: data[:exception]) if data[:exception]
     Notice.find(data[:notice_id]).read
     return nil if !data[:decision].eql?("agree")
     staff_record.update_checkins(checkins)
  end
end
