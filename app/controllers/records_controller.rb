class RecordsController < ApplicationController

  def index
    @current_user
  end

  def new
    @resources = Webservice.dpt_users "dept/users/4028809b3c6fbaa7013c6fbc39900380"
  end





  def create
    params[:record].each do | key , value |
       p key
       p value
    end
  end



  def update

  end


  def modify_atend_record

  end

end
