# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    behave_ids = BehaveType.in(name: ['请假','矿工']).map{|type| type.behave_ids}.flatten
    @stats = StaffRecord.by_period("2013-04-01","2013-04-19").in("checkins.behave_id"=> behave_ids)
    Count.addup @stats
  end

  def update
  end

  def count
    types = BehaveType.find(params[:id]).behaves.map(&:_id)
    @stats = StaffRecord.state('submitted').by_day(Date.today).in("checkins.behave_id" => type)
  end

  def create
    behave_ids = BehaveType.in(name: ['请假','矿工']).map{|type| type.behave_ids}.flatten
    @stats = StaffRecord.state('submitted').by_period("2013-04-01","2013-04-19").in("checkins.behave_id"=> behave_ids).asc(:attend_date)
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

