# -*- coding: utf-8 -*-
class Modify
  include Mongoid::Document

  field :checkins ,type:Hash
  field :decision , type: String
   
  belongs_to :staff_record
  has_many :notices

  after_create do |modify|
    modify.staff_record.apply
  end
  
  after_update do |modify|
    modify.staff_record.approval
  end


  def save_with_change
    staff_record.change?(checkins.values.first) ? save : false
  end


  def handle data
    update_attributes(decision: data[:decision])
    Notice.find(data[:notice_id]).read
    staff_record.update_checkins(checkins.values.first) if data[:decision].eql?("agree")
  end

end
