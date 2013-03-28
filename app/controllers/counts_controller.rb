# -*- coding: utf-8 -*-
class CountsController < ApplicationController

	
  def index
    @stats = sort_by_field Count.addup("2013-03-01","2013-05-01","registered") ,:user_no
  end


  def amount
    @stats = sort_by_field Count.amount("2013-03-01","2013-05-01","registered") , :user_no
    render "index" , :locals => {:type => BehaveType}
  end

end

