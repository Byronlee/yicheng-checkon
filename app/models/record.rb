# -*- coding: utf-8 -*-
class Record
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::WorkFlow
  field :staffid, type: String 
  field :record_person , type: String
  field :record_person_name , type: String
  field :record_zone , type: String
  field :attend_date , type: String
  
  default_scope where(_type: "Record")

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
      record = get_record user.staffid,arg[:time]
      record.checkins.update_all(behave_id: arg[:behave_id])
      record.update_attribute(:attend_date,Date.today)
      record.register
    end
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

  def self.no_number_register arg
    Record.where(_type: "ExceptionRecord").register arg
  end


  def self.query records , params
     records = records.where(record_zone: params[:organization])     if(params[:organization]&&params[:organization]!="")
     records = records.by_period(params[:start_time],params[:end_time]) if(params[:start_time]&&params[:start_time]!="")
     records.paginate(:page => params[:page], :per_page => 5) if records.any?
  end


  def self.query_attach records , params
  #  records = records.where(:checkins => where(params[:field].to_sym => params[:value])) if  params[:order]=="false"
    records = records.where(params[:field].to_sym => params[:value]) if  params[:order]=="false"
    records.paginate(:page => params[:page], :per_page => 5) if records.any?
    #  sort_by(records, params[:field], params[:order])   if params[:order]
  end



  def self.get_tasks  records
    if records
      tasks = records.map do | record |
        { dept_id: User.resource(record.staffid).dept_id, 
          created_at: record.created_at.to_date.to_s
        }
      end
      p tasks
      tasks = tasks.uniq.map do |task|
        {  dept_id: task[:dept_id], 
          created_at: task[:created_at] ,
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
        Record.new_record user.staffid,current_user.username, current_user.id ,dept["id"]
      end
    end
    ExceptionRecord.exception_everyday
  end

# arg[0]: 用户id,arg[1]: 考勤日期,arg[2]: 考勤人,arg[3]: 考勤区域
  def self.new_record *arg
    find_or_create_by(  staffid: arg[0],
                      record_person_name: arg[1],
                      record_person: arg[2],
                      record_zone: arg[3]
                     )
  end
end
