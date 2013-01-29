class RecordsController < ApplicationController
  def index
  end



  def new

    @resources = resources["meili1"]

  end

  def create
    params[:record].each do | key , value |
       p key
       p value
    end

  end

  def update
     
  end


  def modify_atend_record

  end

end
