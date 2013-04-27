# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    @counts = Count.package_counts Count.where(id: nil)
  end

  def create 
    records = Count.select_records params[:start_time],params[:end_time],current_user.users_with_subdept
    counts  = Count.excute_counts records
    @counts = Count.package_counts counts
    render "_count_page" ,:locals => {:counts => @counts,:range_time => params } ,:layout => false
  end

  def export
    render :json => Count.export.to_json
  end
end



