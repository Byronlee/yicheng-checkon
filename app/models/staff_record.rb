# -*- coding: utf-8 -*-
class StaffRecord
  include Mongoid::Record

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

  def self.get_tasks  records
    if records
      tasks = records.map do | record |
        user =  User.resource(record.staffid)
        { dept_id: user.dept_id, 
          created_at: record.created_date,
          dept_name: user.dept_name
        }
      end
      tasks.uniq
    end
  end

  def self.query_map params ,dept_id ,map =""
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
    eval("where(record_zone:'#{dept_id}').state('registered')"+map)
  end

  def self.staff_everyday_records 
    current_user =  User.current_user
    current_user.attend_depts["children"].map do | dept | 
      Department.new(dept["id"]).users.map do | user |
      # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
        new_record(user.staffid  ,        user.username,          user.user_no ,
                          user.nickname_display, current_user.username,  current_user.id  ,
                          current_user.dept_id,  current_user.dept_name )
      end
    end
  end
end
