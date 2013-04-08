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
    @result = TraineeRecord.merge(params[:old_id],params[:condition][:user])
    redirect_to trainees_path
  end
end
