# -*- coding: utf-8 -*-
class Record
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::WorkFlow

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
      record = get_record user.id,arg[:time]
      record.checkins.update_all(behave_id: Behave.default.id)
      record.register
    end
  end

  def self.register arg
    arg[:record].each do | user_id , checks| 
      record = get_record user_id,arg[:time]
      checks.map do |unit_id,behave_id|
        record.checkins.find_by(check_unit_id: unit_id).update_attribute(:behave_id , behave_id)
      end
      record.register
    end
  end


  def self.get_tasks  records
    if records
      taskes = records.map do | record |
        { dept_id: User.resource(record.staffid).dept_id, 
          attend_date: record.attend_date 
        }
      end
      tasks = taskes.uniq.map do |task|
        {  dept_id: task[:dept_id], 
          attend_date: task[:attend_date] ,
          dept_name: Department.new(task[:dept_id]).name
        }
      end 
    end
  end

  def self.default_everyday_records 
    current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
    current_user.attend_depts["children"].map do | dept | 
      Department.new(dept["id"]).users.map do | user |
      # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
      Record.new_record user.id,Date.today,current_user.username,dept["name"]
      end
    end
  end

  # arg[0]: 用户id,arg[1]: 考勤日期,arg[2]: 考勤人,arg[3]: 考勤区域
  def self.new_record *arg
    find_or_create_by(  staffid: arg[0],
                      attend_date: arg[1],
                      record_person: arg[2],
                      record_zone: arg[3]
                     )
  end
end
