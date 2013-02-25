# encoding: utf-8
class Record
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :staffid , type:  Integer
  field :record_person , type: String
  field :attend_option , type: String ,default: "出勤一天"
  field :record_zone , type: String
  field :last_updated , type: Time
  field :attend_date , type: Time

  has_one :definition


 state_machine :initial => :init  do
    event :attend do
      transition :init => :saved
    end

    event :time_out do
      transition :saved => :submitted
    end

  end


  def self.whenever_add
     create!
  end

  def self.attend


  end


end
