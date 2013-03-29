# encoding: utf-8
class TraineesController < ApplicationController

  def index
    @trainees = Trainee.all.decorate
  end

  def create
    @trainee = Trainee.create!(params[:trainee])
    redirect_to trainees_path
  end

  def ajax_user_select
    users = Department.new(params[:dept_id]).users.map do |u|
      [u.username,u.staffid]
    end
    select = {type: "users" , options: users, tips: "--请选择--"}
    render "common/_organization_select",locals:{ :select => select},:layout => false
  end

  def merge
    @result = TraineeRecord.merge(params[:o_id],params[:n_id])
    redirect_to trainees_path
  end
end
