# -*- coding: utf-8 -*-
module Mongoid
  module Content
    extend ActiveSupport::Concern


    module InstanceMethods

      def modify_notice_content
        record = modify.staff_record.decorate
        launcher = User.resource(self.launcher)    
        content = launcher.username+'('+launcher.ancestors+')'+opt_str+'申请将'\
                  +record.staff_name+'('+record.staff.ancestors+')'+record.created_date+'日'      
        modify.checkins.values.first.each do |check_unit_id,behave_id|
          old_behave = record.checkins.find_by(check_unit_id: check_unit_id).behave.name
          new_behave = Behave.find(behave_id).name
          if !old_behave.eql?(new_behave)
            content << ',<strong>'+CheckUnit.find(check_unit_id).name+'的考勤'
            if  User.current_user.approval?
              content <<  '变为'+new_behave+'</strong>'  
            elsif User.current_user.registrar?
              content <<  '由'+old_behave+'变为'+new_behave+'</strong>' 
            end
          end
        end
        update_attribute(:content, content)  
      end
      
      def opt_str
        return '' unless User.current_user.approval?
        modify.decision.eql?('agree') ? '同意你' : '拒绝你' 
      end
      
    end
    
    module  ClassMethods 
    end
  end
end
