# -*- coding: utf-8 -*-
class StaffRecordsController < ApplicationController

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
         
   end

   def operate
     @records = StaffRecordDecorator.new( StaffRecord.query(params,current_user).paginate(:page => params[:page])  )
     session[:query_map] = Rails.configuration.staff_record_query_map   
     render "common/_table_show_records",locals:{:records => @records },:layout => false if env["REQUEST_METHOD"].eql?("POST")
   end

end
