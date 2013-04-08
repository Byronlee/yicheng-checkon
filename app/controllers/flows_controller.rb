# -*- coding: utf-8 -*-
class FlowsController < ApplicationController

   def apply
     Message.launch params
     redirect_to operate_staff_records_path
   end
   
   def view
     Message.find(params[:message_id]).view
     redirect_to root_path 
   end

   def approve
     Message.reply(params)
     redirect_to root_path 
   end
end
