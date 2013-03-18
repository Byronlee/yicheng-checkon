class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.create(params[:user])
    render :index
  end
end
