# -*- coding: utf-8 -*-
module Mongoid
  module Content
    extend ActiveSupport::Concern


    module InstanceMethods

      def examine_notice_content
        launcher = User.resource(self.launcher)   
        content = launcher.username+'('+launcher.ancestors+')需要你审核'+examine.start_time+'日至'+examine.end_time+'日之间的考勤数据'
        update_attribute(:content, content)  
      end

      def modify_notice_content current_user 
        record = modify.staff_record
        launcher = User.resource(self.launcher)    
        content = launcher.username+'('+launcher.ancestors+')'+opt_str(current_user,modify)+'将'\
                  +record.user.username+'('+record.user.ancestors+')'+record.created_date+'日'      
        modify.checkins.each do |check_unit_id,behave_id|
          old_behave = record.checkins.find_by(check_unit_id: check_unit_id).behave.name
          new_behave = Behave.find(behave_id).name         
          if current_user.approval?
            content << unit_str(check_unit_id)+'变为'+new_behave+'</strong>'  
          elsif current_user.registrar?
            if !old_behave.eql?(new_behave)
              content << unit_str(check_unit_id)+'由'+old_behave+'变为'+new_behave+'</strong>' 
            end
          end
        end
        update_attribute(:content, content)  
      end
      
      def unit_str unit_id
        ',<strong>'+CheckUnit.find(unit_id).name+'的考勤'
      end

      def opt_str current_user,modify
        return '' if modify[:update_way]
        return '申请' unless current_user.approval?
        modify.decision.eql?('agree') ? '同意你申请' : '拒绝你申请' 
      end
      
    end
    
    module  ClassMethods 
    end
  end
end
