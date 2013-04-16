# -*- coding: utf-8 -*-
class CountsController < ApplicationController

	
  def index
     if session[:query_map] 
       @stats = Count.addup(session[:query_map]).sort_by{|x|x[:user_no]}
     else
       redirect_to root_url
     end
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

