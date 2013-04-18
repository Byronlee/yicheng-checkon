# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    @stats = Count.all
  end

  def update
    types = BehaveType.find(params[:id]).behaves.map(&:_id)
    @stats = StaffRecord.state('submitted').by_day(Date.today).in("checkins.behave_id" => type)
  end

end

