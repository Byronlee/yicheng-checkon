# -*- coding: utf-8 -*-
class Examine
  include Mongoid::Document

   field :start_time ,type: String
   field :end_time ,  type: String
   field :state , type: Boolean, default: true
  
   has_many :proces
   has_many :notices

  def self.unfinish_examine
    where(state: true).first
  end
  
  def save_with_no_old_examine 
    Examine.unfinish_examine.blank? ? save : false
  end

  def marker
    "#{proces.where(state: true).count}/#{proces.count}"
  end  

  def percent
    "#{(proces.where(state: true).count.to_f/proces.count.to_f*100).round(1)}"+"%"
  end

end
