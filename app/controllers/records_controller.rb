# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

  before_filter :initialize_records, only: [:index]
  before_filter :current_user

 # 根据 考勤日期和 部门，返回 那些部门的考勤没有注册
  def index
    if @records.any?
      @tasks= (@records.map{ |record| { :dept_id => User.new(record.staffid).dept_id, :attend_date => record.attend_date} }
               ).uniq.map do |task|
                {dept_id: task[:dept_id], attend_date: task[:attend_date] ,dept_name: Department.new(task[:dept_id]).name}
      end 
    end
  end


  def new
    @resource ={dept_name: params[:dept_name] ,
                time: params[:time],
                users: Department.new(params[:dept_id]).users }
  end

  def create
    # key 表示user_id value 是一个hash，他的key表示check_unit,value表示behave
    @checkins =[]
    params[:record].each do | user_id , checks|
      record =  Record.get_record user_id,params[:time]
      checks.map do |unit_id,behave_id|
        record.checkins.find_by(check_unit_id: unit_id).update_attribute(:behave , behave_id)
      end
      record.register
    end
    redirect_to root_url
  end

  def fast_register
    dept_id = params[:dept_id]
    behave_id  = params[:behave_id]
    Department.new(dept_id).users.map do | user |
      record =  Record.get_record user.id,params[:time]
      record.checkins.update_all(behave: behave_id)
      record.register
    end
    redirect_to root_url
  end

  def show
  end


  def whether_checkin 
    if params[:option]=="yes"
      current_user.attend_depts["children"].map do | dept | 
         Department.new(dept["id"]).users.map do | user |
          # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
          Record.find_or_create_by(staffid: user.id, attend_date: Time.now.to_date ,record_person: current_user.username, record_zone: dept["name"])
        end
      end
    end
    redirect_to root_url
  end

  private 
   def initialize_records
      @records = Record.state('checking')
   end
end
