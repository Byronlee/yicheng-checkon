# -*- coding: utf-8 -*-
class Crontask 

  def self.produce_everyday_records 
    users = Settings.scope.map do |region_id|
      $ACCESSOR.dept_users_with_subdept(region_id).map do |user_id|
        {staffid: user_id}
      end
    end.flatten
    StaffRecord.create!(users)
  
    Trainee.scoped.map do | user |  
      TraineeRecord.create!(staffid: user.id)
    end
  end


  def self.submit_everyday_records
    [StaffRecord , TraineeRecord].each do |item |
      item.where(attend_date: Date.today).state("registered").each{ |record|  record.submit }
    end
  end

  def self.three_continue_leave
    behave = Behave.find_by(name: '离职')
    result = [Date.today,Date.yesterday,Date.yesterday - 1].inject(StaffRecord) do |object,date|
      object.and({:created_date => date , "checkins.behave_id" => behave.id})
    end
    unless result.blank?
      user = User.resource(result.first.staffid)
      NoticeType.find_by(name: 'exception_leave').notices.create(
                     launcher: 'system',
                     receiver: 'approval',
                     content:  "<strong>#{user.username}(#{user.ancestors})</strong>连续三天离职,请做相应的处理")
    end
  end


  def self.unfinished_attend_task
    return if (records = StaffRecord.state("checking")).blank?
    Settings.scope.map do |region_id|
      $ACCESSOR.dept_tree(region_id)[:children].map do |dept|
        group_names = dept[:children].map do |group|
          reds = records.in(:staffid => $ACCESSOR.dept_users_with_subdept(group[:id]))
          next if reds.count == 0
          group[:name]
        end.flatten.compact
        next if group_names.blank?
        ancestor = $ACCESSOR.dept_attr(region_id)["SD_DEPT_NAME"] + '/'+ dept[:name]+'['+group_names.join(',')+']'
        NoticeType.find_by(name: 'unfinished_attend').notices.create(
          launcher: 'system',
          receiver: 'approval',
          content:  "(<strong>#{ancestor}</strong>)未完成今天的考勤任务,请做相应的处理")

      end
    end
  end


#  def self.unfinished_attend
#    dept_names = StaffRecord.all.map do | record|
#      User.resource(record.staffid).ancestors if record.registered?
#    end
#    dept_names.uniq.compact.map do |name|
#      NoticeType.find_by(name: 'unfinished_attend').notices.create(
#                     launcher: 'system',
#                     receiver: 'approval',
#                     content:  "(<strong>#{name}<strong>)未完成今天的考勤任务,请做相应的处理")
#    end
#  end
end
