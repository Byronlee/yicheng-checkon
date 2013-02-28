class RecordsController < ApplicationController


  def index




   #  @ary = [] 
   #  data = Record.state("checking")
   #  data1 = data.map do |v|
   #    { groupid: Webservice.getData("user/id/"+v.staffid)["SU_DEPT_ID"],created_at: v.created_at.to_s }
   #  end
   #  data1.uniq.map do |v|
   #    @ary << {groupid: v[:groupid],created_at: v[:created_at],group_name: Webservice.getData("dept/id/"+v[:groupid])["SD_DEPT_NAME"]}
   #  end 
   # p "============="
   #  p @ary

  end

  def new



#     groupid = params[:groupid]
#     @time    = params[:time]
#     #@resources = Webservice.dpt_users "dept/users/4028809b3c6fbaa7013c6fbc39900380"
#     @resources = Webservice.dpt_users "dept/users/"+groupid
# #   @records = Record.where(:created_at.gte => time,:created_at.lt => (time.to_time)+1.days)




  end

  def create


    # params[:record].each do | key , value |
    #   p key
    #   p value
    #   Record.attend key,value,params[:time]
    # end
    # redirect_to :action => "index"


  end


  def update

  end


  def modify_atend_record

  end

end
