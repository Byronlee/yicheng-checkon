# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
   @counts = Count.count
  end

  def create 
    Count.create params
    range_time ={:start_time: params[:start_time],
                 :end_time: params[:end_time]}
    render "_count_page" ,:locals => {:counts => Count.count,
                                      :range_time => range_time } ,:layout => false
  end

end

