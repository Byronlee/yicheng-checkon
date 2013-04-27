# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
   @counts = Count.counts(current_user.dept_users_with_subdept)
  end

  def create 
    Count.create params
    range_time ={start_time: params[:start_time],
                 end_time: params[:end_time]}
    render "_count_page" ,:locals => {:counts => Count.counts(current_user),
                                      :range_time => range_time } ,:layout => false
  end

  def export
    render :json => Count.export.to_json
  end
end

