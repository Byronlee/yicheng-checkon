# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    @counts = Count.package_counts Count.all
  end

  def create 
    @counts = Count.create params[:start_time],params[:end_time],current_user.users_with_subdept
    render "_count_page" ,:locals => {:counts => @counts,:range_time => params } ,:layout => false
  end

  def export
    message = Count.export(params[:start_time],params[:end_time],current_user.users_with_subdept)
    render :json => message.to_json
  end
end
