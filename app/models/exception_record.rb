# encoding: utf-8
class ExceptionRecord 
  include Mongoid::Document
  include Mongoid::WorkFlow
  belongs_to :user

  field :staffid, type: String # 用户下信息
  field :staff_name , type: String 
  field :user_no, type: String 
  field :nick_name, type: String 
  field :record_person , type: String # 记录人信息
  field :record_person_name , type: String
  field :record_zone , type: String #登记区域信息
  field :record_zone_name , type: String 
  field :attend_date , type: String
  field :created_at, type: String,default: Date.today.to_s

  embeds_many :checkins

  state_machine initial: :checking do
    event :register do
      transition [:checking] => :registered
    end

    event :submit do
      transition [:registered] => :submitted
    end
  end
  
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
# default_scope where(_type: "ExceptionRecord")
# attr_accessible :_type,:record_zone,:record_person,:attend_date,:staffid
# attr_accessible :check_unit_id,:behave_id,:created_at,:state

  @current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")

  def self.exception_everyday users=nil
    users ||= User.all
    users.map do | u |
      u.is_first ? previous(u) : today(u)
    end
  end

  def self.previous u
    (0...(u.initialized_days)).map do |t|
      new_e_record u,Date.today-t,@current_user.username,"meili"
    end
    u.not_first
  end

  def self.today u
    new_e_record u,Date.today,@current_user.username,"meili"
  end

  def self.new_e_record *arg
    arg[0].exception_records.create(  created_at: arg[1],
                                               record_person: arg[2],
                                               record_zone: arg[3],
                                               staffid: arg[0].id)
  end

  def self.merge o_id,n_id
     user = User.find(o_id)
     user.exception_records.map do |r|
       r.update_attributes(_type: "Record")
       r.staffid =  n_id
       r.save
     end
     user.destroy
  end

  def self.exception_records
    self.or({state: "checking"},{state: "registered",attend_date: Date.today})
  end

  def self.auto_submit
    Record.send(:auto_submit)
    super
  end

  def self.get_record id,time
    User.find(id).exception_records.find_by(created_at: time)
  end

  def self.register arg
    arg[:record].each do | user_id , checks| 
      record = get_record user_id,arg[:time]
      checks.map do |unit_id,behave_id|
        record.checkins.find_by(check_unit_id: unit_id).update_attribute(:behave_id , behave_id)
      end
      record.update_attribute(:attend_date,Date.today)
      record.register
    end
  end
end
