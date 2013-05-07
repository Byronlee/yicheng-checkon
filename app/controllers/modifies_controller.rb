# -*- coding: utf-8 -*-
class ModifiesController < ApplicationController

   def create
     modify = Modify.new(params[:modify][:data])
     if modify.save_with_change
       modify.notices.create(params[:modify][:notice]).modify_notice_content current_user
       unless params[:modify][:data][:update_way].blank?
         modify.staff_record.send(params[:modify][:data][:update_way],params[:modify][:data]) 
       end
       flash[:success] = t('controller.modifies.success')
     else
       flash[:error] =  t('controller.modifies.error')
     end
     redirect_to(:back)
   end

   def update
     notice = Notice.create(params[:modify][:notice])
     notice.modify.handle(params[:modify][:data])
     notice.modify_notice_content current_user
     flash[:success]  =  "处理成功！"
     redirect_to :back
   end

   def destroy 
     Notice.find(params[:modify][:notice_id]).read
     flash[:success]  =  "处理成功！"
     redirect_to :back
   end
end
