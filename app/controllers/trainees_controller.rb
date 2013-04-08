# encoding: utf-8
class TraineesController < ApplicationController

  def index
    @trainees = Trainee.all.decorate
  end

  def create
    @trainee = Trainee.new_trainee params
    redirect_to trainees_path
  end

  def ajax_dept_users_select
    users = Department.new(params[:dept_id]).users.map do |u|
      [u.username,u.staffid]
    end
    select = {type: "users" , options: users, tips: "--请选择用户--"}
    render "common/_organization_select",locals:{ :select => select},:layout => false
  end

  def merge
    if Trainee.find(params[:old_id]).finish?
      flash[:error] = '你还没有完成该员工的考勤任务,请完成后重试!'
    else
      @result = TraineeRecord.merge(params[:old_id],params[:condition][:users])
      flash[:notice] = '成功合并员工考勤数据'
    end
      redirect_to trainees_path
  end
end
