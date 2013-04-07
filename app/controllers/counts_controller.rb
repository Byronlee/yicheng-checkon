# -*- coding: utf-8 -*-
class CountsController < ApplicationController

	
  def index
    @stats = Count.addup("2013-03-01","2013-05-01","submitted")
  end


  def amount
    @stats = Count.amount("2013-03-01","2013-05-01","submitted") 
    render "index" , :locals => {:type => BehaveType}
  end

end

