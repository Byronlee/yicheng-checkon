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

  # 自动生成本条记录的检查数据
  after_create do |record|
    if checkins.count == 0
      CheckUnit.each do |unit|
        record.checkins << Checkin.create!( check_unit: unit, behave: Behave.default )
      end
    end
  end
end
