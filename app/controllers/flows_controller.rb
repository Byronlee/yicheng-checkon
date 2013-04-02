# -*- coding: utf-8 -*-
class FlowsController < ApplicationController

   def apply
     StaffRecord.find(params[:record_id]).apply
     Message.new_message params
     redirect_to operate_staff_records_path
   end


   def approval
 #    StaffRecord.approval params
   end
end
