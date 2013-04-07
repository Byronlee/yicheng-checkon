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
     @records = StaffRecordDecorator.new( StaffRecord.query(params,current_user.dept_id ).paginate(:page => params[:page])  )
   end

   def query
     results = StaffRecordDecorator.new( StaffRecord.query(params,current_user.dept_id ).paginate(:page => params[:page])  )
     render "common/_table_show_records",locals:{:records => results },:layout => false
   end
 end
