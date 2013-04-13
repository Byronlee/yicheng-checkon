# -*- coding: utf-8 -*-
class ModifiesController < ApplicationController

   def show
   end


   def create
     modify = Modify.new(params[:modify][:data])
     if modify.valid?
       modify.save
       modify.notices.create(params[:modify][:notice]).modify_notice_content
       flash[:success] = t('view.flows.apply.success')
     else
       flash[:error] = modify.errors.first[1]
     end
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
