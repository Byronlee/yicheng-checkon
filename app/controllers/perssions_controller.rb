class PerssionsController < ApplicationController

  def index
    dept_scope = $ACCESSOR.registrar_attend_scope(current_user.staffid)
    tr_ids = $ACCESSOR.users_with_role(:tempregistrar,dept_scope) 
    @users = tr_ids.map {|tr_id| User.resource(tr_id)}
  end

  def create
    $PERSSION.set_peroid(params[:user_id],{begin: Date.tomorrow,end: Date.tomorrow})
  end

  def destroy
    $PERSSION.remove(params[:user_id])   
  end
end
