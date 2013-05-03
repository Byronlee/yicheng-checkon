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
                     launcher: user.staffid,
                     receiver: 'approval',
                     content:  user.username+'('+user.ancestors+')连续三天离职,请做相应的处理')
    end
  end
    
end
