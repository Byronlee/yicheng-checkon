# encoding: utf-8
class Record
  include Mongoid::Document
  include Mongoid::Timestamps
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

  def self.whenever_add
     create!
  end

def self.attend id,opt,time
  record = Record.where(:created_at.gte => time,:created_at.lt => (time.to_time)+1.days,staffid: id).update(attend_option: opt,state: "saved")
end

def self.state state
  where(state: state)
end

end
