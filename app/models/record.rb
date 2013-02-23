# -*- coding: utf-8 -*-

class Record
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :period, type: Date
  belongs_to :user, class_name: 'Unirole::User'
  has_many :checkins

  validates_presence_of :period, :user
  validates_uniqueness_of :period, scope: [:user]

  # 生成本条记录的检查数据
  def create_checkins
    CheckUnit.each do |unit|
      checkins << Checkin.create!( record: self, check_unit: unit, behave: Behave.default )
    end
  end


  # --------------------------------------------------------------------------------
  # 以下为原有内容，暂未删减
  # --------------------------------------------------------------------------------

  field :staffid , type:  Integer
  field :record_person , type: String
  field :attend_option , type: String ,default: "出勤一天"
  field :record_zone , type: String
  field :attend_date , type: Time

  state_machine :initial => :init  do
    event :attend do
      transition :init => :saved
    end

    event :time_out do
      transition :saved => :submitted
    end
  end
end
