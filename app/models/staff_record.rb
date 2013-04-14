# -*- coding: utf-8 -*-
class StaffRecord
  include Mongoid::Record

  has_many :modifies

  def self.by_period first,last  
    between(created_date: [first,last])
  end

  def self.fast_register arg
    Department.new(arg[:dept_id]).users.map do | user |
      record = get_record user.staffid,arg[:time]
      record.checkins.update_all(behave_id: arg[:behave_id])
      record.update_attribute(:attend_date,Date.today)
      record.register
    end
  end

  def self.trainee_register arg
    TraineeRecord.register arg
  end


  def self.staffs current_user # 得到一个文员当天的考勤任务(包括已完成的) 且还没有提交的
    unique by_period(Date.today-1,Date.today+1).where(record_person: current_user.staffid).in(state: ["checking","registered"])
  end


  def self.unique records
    if records
      tasks = records.map do | record |
        user =  User.resource(record.staffid)
        { dept_id: user.dept_id, 
          created_at: record.created_date,
          dept_name: user.dept_name ,
          state: record.state
        }
      end
      tasks.uniq.sort_by! do |item|
        [item[:state] ,item[:dept_name]]
      end
    end
  end



  def self.query params ,current_user ,map ="StaffRecord.state('submitted')"
    if params[:type].eql?("attach")
      if params[:order].eql?("false")  #不排序 有两种查询(是不是考勤项) 暂时不做根据考勤项来查询
        map += ".where(#{params[:field].to_sym}: /#{params[:value]}/)"
      else
        map # 这里是根据 字段的升序 和降序差需代码 由 simlegate 来完成！
      end 
    else
      if params[:start_time]
        map += ".by_period('#{params[:start_time]}','#{params[:end_time]}')" unless params[:start_time].empty?
        params[:dept_id]&&!params[:dept_id].empty?     ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" :
        params[:region_id]&&!params[:region_id].empty? ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" :
        params[:cell_id]&&!params[:cell_id].empty?     ? map += ".in(staffid: #{Webservice.users_with_subdept(params[:dept_id])})" : map
      end
    end
    current_user.approval? ? map : (map += ".where(record_zone:'#{current_user.dept_id}')")
    Rails.configuration.staff_record_query_map = map
    eval(map)
  end

   def change? checks
     bool = checks.map do |check_unit_id,behave_id|
       checkins.find_by(check_unit_id: check_unit_id).behave_id.to_s.eql?(behave_id)
     end
     bool.all? ? false : true
   end

   def update_checkins(checks)
     checks.map  do |check_unit_id , behave_id|
       checkins.find_by(check_unit_id: check_unit_id).update_attribute(:behave_id ,behave_id)
     end
   end
   



end
