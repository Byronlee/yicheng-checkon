# -*- coding: utf-8 -*-
class FlowsController < ApplicationController

   def apply
     Message.launch?(params) ? (flash[:success] = t('view.flows.apply.success')) : (flash[:error] = t('view.flows.apply.error'))
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
