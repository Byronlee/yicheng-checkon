# -*- coding: utf-8 -*-
class StaffRecordsController < ApplicationController

   def index
    @records =  StaffRecord.state('submitted').limit(20)
    @records =  @records.paginate(:page => params[:page], :per_page => Settings.per_page)
   end

   def show
     @resource ={
       dept_name: params[:dept_name] ,
       time:  params[:time],
       users: Department.new(params[:dept_id]).users_with_priod_checkins(params[:time])
      }
   end

   def update
     StaffRecord.send(params[:register_way].to_sym , params ,current_user)
     redirect_to root_url
   end

   def search
     @records = StaffRecord.state('submitted').by_period(params[:start_time],params[:end_time]).by_staffid(params[:dept][:user_id])
     unless params[:search][:behave_id].blank?
       @records = @records.by_behave_id params[:search][:behave_id]
     end
     @records = @records.paginate(:page => params[:page], :per_page => Settings.per_page)
     render "common/_table_show_records",locals:{:records => @records },:layout => false
   end
end
