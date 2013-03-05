# -*- coding: utf-8 -*- class Record
class Record
  include Mongoid::Document
  include Mongoid::Timestamps

  field :staffid, type: String 
  field :record_person , type: String
  field :record_zone , type: String
  field :attend_date , type: String

  attr_accessor :checks 

  index({state: 1}) 
  has_many :checkins

 # field :period, type: Date

  state_machine initial: :checking do
    event :register do
      transition [:checking] => :registered
    end


    event :submit do
      transition [:registered] => :submited
    end
  end

 # validates_presence_of :period, :user
#  validates_uniqueness_of :period, scope: [:user]

  # 自动生成本条记录的检查数据
  after_create do |record|
    if checkins.count == 0
      CheckUnit.all.each do |unit|
        record.checkins << Checkin.create!( check_unit_id: unit.id, behave_id: Behave.default.id )
      end
    end
  end

  def self.state state
    where(state: state)
  end

  def self.get_record id,time
    find_by(staffid: id, attend_date: time)
  end

  def update_checkins attrs
    checkins.update_attributes attrs
  end

  def self.cal_period(num)
    Record.all.keep_if { |e| (Date.today - e.created_at.to_date).to_i == num  }
  end


 
  # def << arry
  #   self.checkins = arry
  # end

end
