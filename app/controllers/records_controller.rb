class RecordsController < ApplicationController
  def index
  end



  def new

    @resources = resources["meili1"]

  end

  def create
<<<<<<< HEAD
   sta = params[:staff]
   render :json => sta
=======

    params[:record].each do | key , value |
       p key
       p value
    end



>>>>>>> b05df39a81f56baf90ee83b0c4f2d4f1e77e7d91
  end

  def update
     
  end


  def modify_atend_record

  end

end
