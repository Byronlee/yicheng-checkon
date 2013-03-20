# encoding: utf-8
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.create(params[:user])
    render :index
  end

  def ajax_user_select
    users = Department.new(params[:dept_id]).users.map do |u|
      [u.username,u.staffid]
    end
    select = {type: "users" , options: users, tips: "--请选择用户--"}
    render "common/_organization_select",locals:{ :select => select},:layout => false
  end

  def merge
    @result = ExceptionRecord.merge(params[:o_id],params[:n_id])
    render action: "index"
  end
end
