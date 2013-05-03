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

end
