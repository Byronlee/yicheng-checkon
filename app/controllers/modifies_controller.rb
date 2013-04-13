# -*- coding: utf-8 -*-
class ModifiesController < ApplicationController

   def create
     modify = Modify.new(params[:modify][:data])
     if modify.save_with_change
       modify.notices.create(params[:modify][:notice]).modify_notice_content
       flash[:success] = t('view.flows.apply.success')
     else
       flash[:error] =  t('view.flows.apply.error')
     end
     redirect_to operate_staff_records_path
   end
   

   def update
     notice = Notice.create(params[:modify][:notice])
     notice.modify.handle(params[:modify][:data])
     notice.modify_notice_content
     redirect_to root_path 
     #  todo 提示处理结果
   end

   def destroy 
     Notice.find(params[:modify][:notice_id]).read
     redirect_to root_path 
   end



end
