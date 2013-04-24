# -*- coding: utf-8 -*-
module CountsHelper

  def count_table_titles 
    ["序号","所在位置","工号","姓名","请假类型","天数","详情"]
  end

  def format v
    v.eql?(0) ? "" : v
  end

  def count_radix
    Settings.count_radix
  end

  def behave_types
    BehaveType.all.map{ |type| [type.name,type.id]}
  end

  def unfinish_examine
    Examine.unfinish_examine
  end

  def can_count? counts
    unfinish_examine.blank? ? true : false
  end

  def examine_unfinish_registrar 
    return [] if unfinish_examine.blank?
    unfinish_examine.proces.clone.keep_if{|i|!i.state}
  end

  def current_user_examine_state
   return [] if unfinish_examine.blank?
   proce = unfinish_examine.proces.where(registrar: current_user.staffid).first
   proce.blank? ? false : proce.state
  end

end
