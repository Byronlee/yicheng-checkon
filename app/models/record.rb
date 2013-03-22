# -*- coding: utf-8 -*-
class Record
  include Mongoid::Document
  include Mongoid::WorkFlow
  field :staffid, type: String # 用户下信息
  field :staff_name , type: String 
  field :user_no, type: String 
  field :nick_name, type: String 
  field :record_person , type: String # 记录人信息
  field :record_person_name , type: String
  field :record_zone , type: String #登记区域信息
  field :record_zone_name , type: String 
  field :attend_date , type: String
  field :created_at, type: Date,default: Date.today
  
  default_scope where(_type: "Record")

  index({state: 1}) 

  embeds_many :checkins

  state_machine initial: :checking do
    event :register do
      transition [:checking] => :registered
    end

    event :submit do
      transition [:registered] => :submitted
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
    find_by(staffid: id, created_at: time)
  end

  def self.by_period first,last
    between(attend_date: [first,last])
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


  def self.get_tasks  records
    if records
      tasks = records.map do | record |
        { dept_id: User.resource(record.staffid).dept_id, 
          created_at: record.created_at
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


  def self.query_map params, map =""
    if params[:type].eql?("attach")
      if params[:order].eql?("false")  #不排序 有两种查询(是不是考勤项) 暂时不做根据考勤项来查询
        map += ".where(#{params[:field].to_sym}: /#{params[:value]}/)"
      else
         map # 这里是根据 字段的升序 和降序差需代码 由 simlegate 来完成！
      end 
    else
      map += ".by_period('#{params[:start_time]}','#{params[:end_time]}')" unless params[:start_time].empty?
      params[:dept_id]&&!params[:dept_id].empty?     ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" :
      params[:region_id]&&!params[:region_id].empty? ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" :
      params[:cell_id]&&!params[:cell_id].empty?     ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" : map
    end
  end

  def self.default_everyday_records 
    current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
    current_user.attend_depts["children"].map do | dept | 
      Department.new(dept["id"]).users.map do | user |
      # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
        Record.new_record(user.staffid  ,        user.username,          user.user_no ,
                          user.nickname_display, current_user.username,  current_user.id  ,
                          current_user.dept_id,  current_user.dept_name )
      end
    end
    ExceptionRecord.exception_everyday
  end

# arg[0]: 用户id,arg[1]:用户名字，arg[2]:用户工号， arg[3]:昵称，
# arg[4]: 记录人名字，arg[5]: 记录人id, arg[6]:记录人区域id ，arg[7]:记录人区域名字， ,arg[8]: 考勤日期
  def self.new_record *arg
    find_or_create_by(staffid: arg[0],
                      staff_name: arg[1],
                      user_no: arg[2],
                      nick_name: arg[3],
                      record_person_name: arg[4],
                      record_person: arg[5],
                      record_zone: arg[6],
                      record_zone_name: arg[7],
                     )
  end

  def self.auto_submit
    where(attend_date: Date.today).state("registered").each do |record|
      record.submit
    end
  end
end
