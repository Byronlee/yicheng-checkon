# -*- coding: utf-8 -*-
module CountsHelper

  def count_table_titles 
    ["序号","所在位置","工号","姓名","请假类型","天数","详情"]
  end


  def count_types
    Settings.defult_count_behave_types.inject([]) do |types,type_name |
      types + BehaveType.where(name: type_name).first.behaves.map do |behave|
        [behave.name,behave.id]
      end
    end
  end

  def format v
    v.eql?(0) ? "" : v
  end

  def behave_types
    BehaveType.all.map{ |type| [type.name,type.id]}
  end
end
