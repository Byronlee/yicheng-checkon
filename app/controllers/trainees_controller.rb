# encoding: utf-8
class TraineesController < ApplicationController

  def index
    @trainees = Trainee.belong(current_user).decorate
  end

  def create
    # TODO params[:trainee]  strip
    trainee = Trainee.new(params[:trainee])
    if trainee.save_with_validate(current_user)
      flash[:success] = '成功添加员工'
    else
      flash[:error] = trainee.errors.first[1]
    end
    redirect_to trainees_path
  end

  def merge
    # params[:condition][:dept_id] stand for 'staff_id'
    if (new_id = params[:condition][:dept_id]).blank?
      flash[:error] = '请选择你需要合并的员工'
    elsif Trainee.find(params[:old_trainee_id]).finish?
      flash[:error] = '你还没有完成该无工号员工的考勤任务,请完成后重试!'
    else
      @result = TraineeRecord.merge(params[:old_trainee_id],params[:condition][:dept_id])
      flash[:success] = '成功合并员工考勤数据'
    end
      redirect_to trainees_path
  end
end
