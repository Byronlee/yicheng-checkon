# -*- coding: utf-8 -*-
class MessageDecorator < Draper::Decorator
 delegate_all

 def content
   record = StaffRecord.find(source.record_id).decorate
   launcher = User.resource(source.launcher)
   message = {}
   message[:short] =  launcher.username+'('+launcher.ancestors+')'+opt_str+'申请修改'+record.staff_name+'('+record.staff.ancestors+')'+record.created_date+'日考勤记录'
   message[:long] = launcher.username+'('+launcher.ancestors+')'+opt_str+'申请将'+record.staff_name+'('+record.staff.ancestors+')'+record.created_date+'日'
   source.checkins.each do |check_unit_id,behave_id|
     old_behave = record.checkins.find_by(check_unit_id: check_unit_id).behave.name
     message[:long] << ",<Strong>"+CheckUnit.find(check_unit_id).name+'的考勤由'+old_behave+'变为'+Behave.find(behave_id).name+'</Strong>'
   end
   message
 end


 def opt_str
   if User.current_user.registrar?
     source.decision.eql?('agree') ? '同意你' : '拒绝你' 
   else
     ''
   end
 end
end 
