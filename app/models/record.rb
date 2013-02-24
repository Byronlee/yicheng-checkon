# encoding: utf-8
class Record
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :staffid , type: String 
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

def self.attend id,opt
  record = Record.create(staffid: id,attend_option: opt)
  record.attend
end

def self.state state
  where(state: state)
end

end
