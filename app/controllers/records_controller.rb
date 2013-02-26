class RecordsController < ApplicationController

  def index
    @ary = []
    data = Record.state("init")
    data1 = data.map do |v|
      { groupid: Webservice.getData("user/id/"+v.staffid)["SU_DEPT_ID"],created_at: v.created_at.to_s }
    end
    data1.uniq.map do |v|
      @ary << {groupid: v[:groupid],created_at: v[:created_at],group_name: Webservice.getData("dept/id/"+v[:groupid])["SD_DEPT_NAME"]}
    end
  end

  def new
    groupid = params[:groupid]
    @time    = params[:time]
    @resources = Webservice.dpt_users "dept/users/"+groupid
  end

  def create
    params[:record].each do | key , value |
      Record.attend key,value,params[:time]
    end
    redirect_to :action => "index"
  end
end
