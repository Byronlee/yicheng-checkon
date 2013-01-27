# encoding: utf-8
class Record
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  field :staffid , type:  Integer
  field :record_person , type: String 
  field :attend_option , type: String ,default: "出勤一天" 
  field :record_status , type: String ,default: "未考勤"
  field :record_zone , type: String 
  field :last_updated , type: Time
  field :attend_date , type: Time 
end
