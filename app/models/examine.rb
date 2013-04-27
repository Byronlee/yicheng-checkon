# -*- coding: utf-8 -*-
class Examine
  include Mongoid::Document

   field :start_time ,type: String
   field :end_time ,  type: String
   field :state , type: Boolean, default: false
  
   has_many :proces
   has_many :notices

 
  def unfinish_registrar 
    proces.clone.keep_if{|i|!i.state}
  end
 
  def save_with_have_records
    StaffRecord.by_period(start_time,end_time).state('submitted').blank? ? false : save 
  end

  def percent
    "#{proces.where(state: true).count}/#{proces.count}"
  end  

end
