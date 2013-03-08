# -*- coding: utf-8 -*-
class RecordsController < ApplicationController
  before_filter :initialize_records, :initialize_tasks , only: [:index]
  caches_page :index


  def new
    time = params[:time]
    users =  Department.new(params[:dept_id]).users
    users.each do |user|
      behaves = Record.get_record user.id,time
      user.instance_variable_set(:@behaves,behaves.checkins)
    end
    @resource ={
      dept_name: params[:dept_name] ,
      time: time,
      users: users
     }
  end

  def create

    # key 表示user_id value 是一个hash，他的key表示check_unit,value表示behave
    Record.register params
    redirect_to root_url
  end

  def fast_register
    Record.fast_register params
    redirect_to root_url
  end

  def default_everyday_records 
      current_user.attend_depts["children"].map do | dept | 
         Department.new(dept["id"]).users.map do | user |
          # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
          Record.find_or_create_by(  staffid: user.id, 
                                     attend_date: Time.now.to_date , 
                                     record_person: current_user.username, 
                                     record_zone: dept["name"]
                                  )
        end
      end
  end

  private 
    def initialize_records
      @records_not_register = Record.state('checking')
      @records_today_registered = Record.by_period(Date.today-1,Date.today+1).state("registered")
    end
    
    def initialize_tasks 
      # 根据 考勤日期和 部门，返回 那些部门的考勤没有注册
      @tasks = get_tasks @records_not_register     
      # 找到今天完成的考勤任务
      @tasks_finished = get_tasks @records_today_registered   
    end

    def get_tasks  records
      if records
         taskes= records.map do | record |
           { dept_id: User.new(record.staffid).dept_id, 
             attend_date: record.attend_date 
           }
         end
         tasks = taskes.uniq.map do |task|
          {  dept_id: task[:dept_id], 
             attend_date: task[:attend_date] ,
             dept_name: Department.new(task[:dept_id]).name
          }
        end 
        sort_by_field tasks,:dept_name
      end
    end
end
