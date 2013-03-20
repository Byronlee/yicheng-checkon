# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

  before_filter  :initialize_tasks , only: [:index]
  before_filter  :initialize_query_records , only: [:query , :operate ,:query_attach]
#  caches_page :index


  def show
    @resource ={
      dept_name: params[:dept_name] ,
      time:  params[:time],
      users: Department.new(params[:dept_id]).users_with_priod_checkins(params[:time])
     }
  end

  def tree_dept
    render :json =>  Webservice.get_data("dept_tree/").to_json
  end

  def update
    Record.send(params[:register_way].to_sym , params)
    redirect_to root_url
  end

  def operate
     @records = @query_resource.paginate(:page => params[:page], :per_page => 5)
  end

  def query
    @query_result = Record.query @query_resource , params
    render "common/_table_show_records",locals:{:records => @query_result },:layout => false
  end


  def query_attach
      @query_attach_result = Record.query_attach( @query_result||@query_resource, params)
      render "common/_table_show_records",locals:{:records => @query_attach_result },:layout => false
  end
  
  def ajax_select
    
  end

  def permission
  end

  private 
    def initialize_tasks 
      @tasks = sort_by_field(Record.get_tasks(Record.state('checking')),:dept_name)
      @tasks_finished = sort_by_field(Record.get_tasks(Record.by_period(Date.today-1,Date.today+1).state("registered")),:dept_name)
    end
   
   def initialize_query_records
     @query_resource = Record.in(record_zone: current_user.attend_depts["children"].map{|dept| dept["id"]} ).state("registered")
   end
end
