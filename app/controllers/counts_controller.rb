# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    @stats = Count.all
  end

  def create 
    Count.create params
    redirect_to counts_path
  end
  
  
  def update
    @stats = Count.where("id.behave_id" => "517029571229bc9afb000006") 
    return render "common/_no_content" ,:locals =>{:message => "目前没有数据可以统计" } ,:layout => false if  @stats.blank?
    render "_count_result" ,:locals =>{:stats => @stats} ,:layout => false
  end

end

