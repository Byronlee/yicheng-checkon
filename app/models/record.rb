# -*- coding: utf-8 -*-
class Record
  include Mongoid::Document
  include Mongoid::Timestamps

  field :staffid, type: String 
  field :record_person , type: String
  field :record_zone , type: String
  field :attend_date , type: String

  index({state: 1}) 

  embeds_many :checkins

  state_machine initial: :checking do
    event :register do
      transition [:checking] => :registered
    end

    event :submit do
      transition [:registered] => :submited
    end
  end

  # 自动生成本条记录的检查数据
  after_create do |record|
    if checkins.count == 0
      CheckUnit.all.each do |unit|
       record.checkins.create!( check_unit_id: unit.id, behave_id: Behave.default.id )
      end
    end
  end
  def self.state state
    where(state: state)
  end

  def self.get_record id,time
    find_by(staffid: id, attend_date: time)
  end

  def self.by_period first,last
    where(attend_date: {"$gte"=>first, "$lte"=>last})
  end

  def self.fast_register arg
    Department.new(arg[:dept_id]).users.map do | user |
      record =  Record.get_record user.id,arg[:time]
      record.checkins.update_all(behave_id: Behave.default.id)
      record.register
    end
  end

  def self.register arg
    arg[:record].each do | user_id , checks| 
      record =  Record.get_record user_id,arg[:time]
      checks.map do |unit_id,behave_id|
        record.checkins.find_by(check_unit_id: unit_id).update_attribute(:behave_id , behave_id)
      end
    record.register
    end
  end
end
