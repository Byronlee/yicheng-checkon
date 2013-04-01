# -*- coding: utf-8 -*-
class StaffRecordsController < ApplicationController

  before_filter  :initialize_tasks , only: [:index]
#  caches_page :index

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



   def apply
#     StaffRecord.apply params
   end


   def approval
 #    StaffRecord.approval params
   end

   private
   def initialize_tasks
     @tasks = sort_by_field(StaffRecord.get_tasks("unfinish"),:dept_name)
     @tasks_finished = sort_by_field(StaffRecord.get_tasks("finished"),:dept_name)
   end
 end
