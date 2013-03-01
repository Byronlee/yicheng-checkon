# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

  before_filter :initialize_records, only: [:index]

 # 根据 考勤日期和 部门，返回 那些部门的考勤没有注册
  def index
      if @records
        @tasks= (@records.map{ |record| { :dept_id => User.new(record.staffid).dept_id, :attend_date => record.attend_date.to_s} }
                ).uniq.map do |task|
                   {dept_id: task[:dept_id], attend_date: task[:attend_date] ,dept_name: Department.new(task[:dept_id]).name}
                 end 
       end
  end


  def new
#     groupid = params[:groupid]
#     @time    = params[:time]
#     @resources = Webservice.dpt_users "dept/users/4028809b3c6fbaa7013c6fbc39900380"
#     @resources = Webservice.dpt_users "dept/users/"+groupid
# #   @records = Record.where(:created_at.gte => time,:created_at.lt => (time.to_time)+1.days)




  end

  def create


    # params[:record].each do | key , value |
    #   p key
    #   p value
    #   Record.attend key,value,params[:time]
    # end
    # redirect_to :action => "index"


  end

  private 
    def initialize_records
      @records = Record.state('checking')
    end
end
