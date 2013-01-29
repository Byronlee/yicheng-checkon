class RecordsController < ApplicationController
  def index
  end



  def new

    @resources = resources["meili1"]

  end

  def create
   sta = params[:staff]
   render :json => sta
  end

  def update
     
  end

  def modify_atend_record

  end

end
