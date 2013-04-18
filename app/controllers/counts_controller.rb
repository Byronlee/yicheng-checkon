# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    types = BehaveType.find("515d55871229bc1410000005").behaves.map(&:_id)
    @stats = StaffRecord.state('submitted').by_period("2013-04-01","2013-04-19").in("checkins.behave_id"=> types).asc(:attend_date)
  end

  def update
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

