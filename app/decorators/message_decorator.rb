# -*- coding: utf-8 -*-
class MessageDecorator < Draper::Decorator
 delegate_all

 def content
   record = StaffRecord.find(source.record_id).decorate
   launcher = User.resource(source.launcher)
   message = {}
   message[:short] = launcher.username+opt_str+'申请修改'+record.staff_name+record.created_date+'考勤记录'
   message[:long] = launcher.username+'('+launcher.ancestors+')'+opt_str+'申请将'+record.staff_name+'('+record.staff.ancestors+')'+record.created_date
   source.checkins.each do |check_unit_id,behave_id|
     old_behave = record.checkins.find_by(check_unit_id: check_unit_id).behave.name
     message[:long] << CheckUnit.find(check_unit_id).name+'的考勤由'+old_behave+'变为'+Behave.find(behave_id).name
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
