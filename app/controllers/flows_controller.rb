# -*- coding: utf-8 -*-
class FlowsController < ApplicationController
  
   skip_load_resource

   def apply
     Message.launch params
     redirect_to operate_staff_records_path
   end
   
   def view
     Message.find(params[:id]).view
     redirect_to root_path 
   end

   def approve
     Message.reply(message,params)
     redirect_to root_path 
   end
end
