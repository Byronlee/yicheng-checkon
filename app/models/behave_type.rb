# -*- coding: utf-8 -*-
class BehaveType
  include Mongoid::Document

  field :name, type: String
  has_many :behaves, class_name: 'Behave'
  behaves = {
             :请假 => ["事假","病假","产假","婚假","丧假"],
             :旷工 =>   ["旷工"],
             :迟到 =>  ["迟到"],
             :调休 =>  ["调休"],
             :离职 => ["离职"],
             :上班 => ["全勤","公出","培训"]}


    # 自动生成本条记录的检查数据
  after_create do |behave_type|
    behaves[behave_type.name.to_sym].each do |bh|
      if bh == "全勤"
        behave_type.behaves.create(name: bh,proper: false,default: true)
      else
        behave_type.behaves.create(name: bh,proper: false)
      end
    end
  end



# validates_presence_of :name
# validates_uniqueness_of :name
end
