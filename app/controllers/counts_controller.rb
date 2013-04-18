# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
     if session[:query_map] 
       @stats = Count.addup(session[:query_map]).sort_by{|x|x[:user_no]}
     else
       redirect_to root_url
     end
  end

  def count
    types = BehaveType.find(params[:id]).behaves.map(&:_id)
    @stats = StaffRecord.state('submitted').by_day(Date.today).in("checkins.behave_id" => type)
  end

  def amount
    if session[:query_map] 
      @stats = Count.amount.sort_by{|x|x[:user_no]}
      render "index" , :locals => {:type => BehaveType}
    else
      redirect_to root_url
    end
  end

end

