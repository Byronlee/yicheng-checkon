# -*- coding: utf-8 -*-
class Crontask 

  # TODO should save in memory then insert db
  def self.produce_everyday_records 
    checkers = Webservice.get_registrars
    checkers.each do |checker_id |     
      cu = User.resource(checker_id)
      cu.extend RegistrarRole
      users = cu.users_with_subdept
      unless users.blank?   # 因为有些 区下面没有children 所以必须判断
        users_hash = users.map do |user_id|          
          {staffid: user_id, record_person: cu.staffid}
        end
        StaffRecord.create!(users_hash)
      end

      Trainee.scoped.map do | user |  
        TraineeRecord.create!(staffid: user.id, record_person: cu.staffid)
      end
    end  # checkers end
  end

  def self.submit_everyday_records
    [StaffRecord , TraineeRecord].each do |item |
      item.where(attend_date: Date.today).state("registered").each{ |record|  record.submit }
    end
  end

end
