# -*- coding: utf-8 -*-
class ExaminesController < ApplicationController

  def index
   @examines = Examine.all
  end


  def create
    examine = Examine.new(params[:examine][:data])
    if examine.save_with_have_records
      checkers = $ACCESSOR.all_users_with_role :registrar
      checkers.each do |checker_id |
        examine.proces.create(registrar: checker_id)
        params[:examine][:notice][:receiver] = checker_id
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
    examine = Examine.find(params[:examine_id])
    examine.proces.where(registrar: current_user.staffid).first.update_attributes(state: true)
    examine.notices.where(receiver: current_user.staffid).first.update_attributes(state: true)
    render "counts/_count_page" ,:locals => {:counts => Count.counts(current_user)}, :layout => false
  end


  def destroy
    examine = Examine.find(params[:examine_id])
    examine.notices.update_all(state: true)
    examine.update_attributes(state: false)
    render "counts/_count_page" ,:locals => {:counts => Count.counts(current_user)}, :layout => false
  end
end
