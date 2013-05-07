class PerssionsController < ApplicationController

  def index
    @users = current_user.tempregistrars.map do |id|
      state = $PERSSION.peroid(id) ? true : false
      { user: User.resource(id),state: state }
    end
    @users.sort! {|x,y| y[:state].to_s <=> x[:state].to_s}
  end

  def create
    $PERSSION.set_peroid(params[:user_id],{begin: Date.tomorrow,end: Date.tomorrow})
    redirect_to perssions_path
  end

  def destroy
    $PERSSION.remove(params[:user_id])   
    redirect_to perssions_path
  end
end
