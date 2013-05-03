# -*- coding: utf-8 -*-
class ExaminesController < ApplicationController

  def index
   @examines = Examine.all.limit(20)
  end

  def create
    examine = Examine.new(params[:examine][:data])
    if examine.save_with_have_records
      checkers = $ACCESSOR.all_users_with_role :registrar
      checkers.each do |checker_id |
        examine.proces.create(registrar: checker_id)
        params[:examine][:notice][:receiver] = checker_id
        params[:examine][:notice][:notice_type_id] = NoticeType.find_by(name: "examine_applied").id
        examine.notices.create(params[:examine][:notice]).examine_notice_content
      end
      flash[:success] ="成功创建审核任务!"
     else
      flash[:error] ="所选时间段内考勤记录为空，可能还为提交考勤记录，创建审核任务失败!"
     end
    redirect_to :action => 'index' 
  end


  def show
    @examine = Examine.find(params[:id]) 
    @counts = Count.create @examine.start_time,@examine.end_time,current_user.users_with_subdept
  end

  def update
    examine = Examine.find(params[:id])
    registrars = $ACCESSOR.users_with_role(:registrar,current_user.dept_id)
    examine.proces.in(:registrar => registrars).update_all(state: true)
    examine.notices.where(receiver: current_user.staffid).first.update_attributes(state: true)
    examine.update_attributes(state: "finished") if examine.proces.map(&:state).all? 
    redirect_to :back
  end

  def destroy
    examine = Examine.find(params[:id])
    examine.notices.update_all(state: true)
    examine.update_attributes(state: 'canceled')
    flash[:success] = '取消成功!'
    redirect_to :action => 'index' 
  end

  def proces_detail
    examine = Examine.find(params[:examine_id])
    render "_proces_detail_content",locals:{:examine => examine },:layout => false
  end
end
