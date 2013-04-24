# -*- coding: utf-8 -*-
class BehaveType
  include Mongoid::Document

  field :name, type: String
  has_many :behaves, class_name: 'Behave'

  # 自动生成本条记录的检查数据
  after_create do |behave_type|
    behaves = Settings.behaves
    behaves[behave_type.name.to_sym].each do |bh|
      if bh == "全勤"
        behave_type.behaves.create(name: bh,proper: false,default: true)
      else
        behave_type.behaves.create(name: bh,proper: false)
      end
    end
  end

  def behave_ids
    behaves.map(&:_id)
  end

  def self.behave_ids_by_name name
    find_by(name: name).behave_ids
  end

# validates_presence_of :name
# validates_uniqueness_of :name
end
