# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

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
    Record.send(params[:register_way].to_sym , params)
    redirect_to root_url
  end


  def operate
     dept_ids = current_user.attend_depts["children"].map do | dept |     
       dept["id"]
     end
     @records = Record.state("registered").in(record_zone: dept_ids)
    @regions =[["东南区" ,  "1243"]]
  end



  def query
     record_zone = params[:cell_id] || params[:region_id] ||  params[:dept_id]
     @result = Record.where(record_zone: record_zone).by_period(params[:start_time],params[:end_time]).state("registered")
    render :operate
  end




  private 
    def initialize_tasks 
      @tasks = sort_by_field( Record.get_tasks(Record.state('checking')), :dept_name)  
      @tasks_finished = sort_by_field( Record.get_tasks(Record.by_period(Date.today-1,Date.today+1).state("registered")) ,:dept_name)
    end
end
