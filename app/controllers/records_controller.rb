# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

  before_filter  :initialize_tasks , only: [:index]
  before_filter  :initialize_query_records 
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
   @records =  RecordDecorator.new(eval(session[:query_map]).paginate(:page => params[:page]))
  end

  def query
    map = session[:query_map]+Record.query_map(params)
    render "common/_table_show_records",locals:{:records => RecordDecorator.new(eval(map).paginate(:page => params[:page]))},:layout => false
  end
  


  private 
    def initialize_tasks 
      @tasks = sort_by_field(Record.get_tasks(Record.state('checking')),:dept_name)
      p "ddddd"
      p @tasks.map{|x| p x }
      debugger
      @tasks_finished = sort_by_field(Record.get_tasks(Record.by_period(Date.today-1,Date.today+1).state("registered")),:dept_name)
    end
   
   def initialize_query_records
     session[:query_map] ="Record.where(record_zone: '#{current_user.dept_id}').state('registered')"
   end
end
