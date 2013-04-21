# -*- coding: utf-8 -*-
class Examine
  include Mongoid::Document

   field :start_time ,type: String
   field :end_time ,  type: String

   has_many :proces
   has_many :notices

   
  def save_with_no_old_examine 
    Proce.where(state: false).blank? ? save : false
  end

end
