# -*- coding: utf-8 -*-
class RecordsController < ApplicationController

  before_filter  :initialize_tasks , only: [:index]
  caches_page :index

#  def new
#    time = params[:time]
#    users =  Department.new(params[:dept_id]).users
#    users.each do |user|
#      behaves = Record.get_record user.id,time
#      user.instance_variable_set(:@behaves,behaves.checkins)
#    end
#  end

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


  private 
    def initialize_tasks 
      @tasks = Record.get_tasks(Record.state('checking')).sort_by_field(:dept_name)
      @tasks_finished = Record.get_tasks(Record.by_period(Date.today-1,Date.today+1).state("registered")).sort_by_field(:dept_name)
    end
end
