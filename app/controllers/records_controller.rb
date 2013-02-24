class RecordsController < ApplicationController

  def index
    @ary = [] 
    data = Record.state("init")
    data.map do |v|
      groupid = Webservice.getData("user/id/"+v.staffid)["SU_DEPT_ID"]
      @ary << {staffid: v.staffid,groupid: groupid,created_at: v.created_at,group_name: Webservice.getData("dept/id/"+groupid)["SD_DEPT_NAME"]}
    end
    p "============="
    p @ary
  end

  def new
    @resources = Webservice.dpt_users "dept/users/4028809b3c6fbaa7013c6fbc39900380"
  end

  def create
    params[:record].each do | key , value |
      Record.attend key,value
    end
    redirect_to :action => "index"
  end


  def update

  end


  def modify_atend_record

  end

end
