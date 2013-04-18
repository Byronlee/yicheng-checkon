# -*- coding: utf-8 -*-
module CountsHelper

  def count_table_titles type
    ["所在位置","工号","姓名"] + type.all.map {|bh| bh.name}
  end

  def format v
    v.eql?(0) ? "" : v
  end

  def behave_types
    BehaveType.all.map{ |type| [type.name,type.id]}
  end
end
