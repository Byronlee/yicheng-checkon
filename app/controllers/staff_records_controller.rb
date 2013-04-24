# -*- coding: utf-8 -*-
class StaffRecordsController < ApplicationController

   def index
    @records =  StaffRecord.state('submitted').limit(20)
   end

   def show
     @resource ={
       dept_name: params[:dept_name] ,
       time:  params[:time],
       users: Department.new(params[:dept_id]).users_with_priod_checkins(params[:time])
      }
   end

   def update
     bool = StaffRecord.send(params[:register_way].to_sym , params)   
     return redirect_to root_url if !params[:register_way].eql?("direct_update")
     bool.all? ? (flash[:success] = t('controller.staff_records.success')) 
               : (flash[:error] = t('controller.staff_records.error'))
     redirect_to operate_staff_records_path
     # todo 如果是人事部直接修改，没有添加修改日志，当人事部修改选择没有变时，也能提交修改！没有判断
   end

   def search
     @records = StaffRecord.state('submitted').by_period(params[:start_time],params[:end_time]).by_staffid(params[:dept][:user_id])
     unless params[:search][:behave_id].blank?
       @records = @records.by_behave_id params[:search][:behave_id]
     end
     render "common/_table_show_records",locals:{:records => @records },:layout => false
   end
end
