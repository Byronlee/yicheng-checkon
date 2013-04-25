# encoding: utf-8
class TraineesController < ApplicationController

  def index
    @trainees = Trainee.belong(current_user)
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
    new_id = params[:dept][:user_id]
    if (new_id = new_id).blank?
      flash[:error] = '请选择你需要合并的员工'
    elsif Trainee.find(params[:old_trainee_id]).finish?
      flash[:error] = '你还没有完成该无工号员工的考勤任务,请完成后重试!'
    elsif StaffRecord.where(staffid: new_id).map(&:checking?).any?
      flash[:error] = '被选择的员工还有未完成的考勤任务,请先完成考勤任务后在合并!'
    else
      @result = TraineeRecord.merge(params[:old_trainee_id],new_id)
      flash[:success] = '成功合并员工考勤数据'
    end
      redirect_to trainees_path
  end
end
