# encoding: utf-8
class TraineesController < ApplicationController

  def index
    @trainees = Trainee.all.decorate
  end

  def create
    trainee = Trainee.new_trainee params
    if trainee.valid?
      trainee.save
      flash[:success] = '成功添加员工'
    else
      flash[:error] = trainee.errors.first[1]
    end
    redirect_to trainees_path
  end

  def ajax_dept_users_select
    users = !params[:dept_id].empty? ? Department.new(params[:dept_id]).users_select : []
    select = {type: "users" , options: users, tips: "--请选择用户--"}
    render "common/_organization_select",locals:{ :select => select},:layout => false
  end

  def merge
    if (new_id = params[:condition][:users]).blank?
      flash[:error] = '请选择你需要合并的员工'
    elsif Trainee.find(params[:old_id]).finish?
      flash[:error] = '你还没有完成该无工号员工的考勤任务,请完成后重试!'
    else
      @result = TraineeRecord.merge(params[:old_id],params[:condition][:users])
      flash[:success] = '成功合并员工考勤数据'
    end
      redirect_to trainees_path
  end
end
