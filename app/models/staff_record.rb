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


  def self.staffs  # 得到一个文员当天的考勤任务(包括已完成的) 且还没有提交的
    unique by_period(Date.today-1,Date.today+1).where(record_person: User.current_user.staffid).in(state: ["checking","registered"])
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



  def self.query params ,dept_id ,map ="StaffRecord.state('submitted')"
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
    User.current_user.approval? ? map : (map += ".where(record_zone:'#{dept_id}')")
    Rails.configuration.staff_record_query_map = map
    eval(map)
  end

   def self.is_change? record, behaves
     plus = 1
     behaves[:record].values.first.each do |check_unit_id,behave_id|
       old_behave = record.checkins.find_by(check_unit_id: check_unit_id).behave.name
       new_behave = Behave.find(behave_id).name
       plus +=1  if old_behave.eql?(new_behave)       
     end
     plus==3 ? false : true
   end
end