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
     StaffRecord.send(params[:register_way].to_sym , params)
     redirect_to root_url
   end


   def operate
     @records = StaffRecordDecorator.new( StaffRecord.query(params,current_user).paginate(:page => params[:page])  )
     session[:query_map] = Rails.configuration.staff_record_query_map   
     render "common/_table_show_records",locals:{:records => @records },:layout => false if env["REQUEST_METHOD"].eql?("POST")
   end

end
