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
    unfinish_examine.proces.clone.keep_if{|i|!i.state}
  end



end
