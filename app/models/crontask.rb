# -*- coding: utf-8 -*-
class Crontask 

  # TODO should save in memory then insert db
  def self.produce_everyday_records 
    checkers = Webservice.get_data "/registrars"
    checkers.each do |checker_id |
      cu = User.resource(checker_id)
      cu.class_eval {include RegistrarRole}
      children =  cu.attend_depts["children"]
      if children   # 因为有些 区下面没有children 所以必须判断
        staff_records = children.map do | dept |             
          Department.new(dept["id"]).users.map do | user |
            StaffRecord.new(staffid:    user.staffid, 
                            staff_name:   user.username,
                            user_no:    user.user_no ,
                            nickname:  user.nickname_display,
                            record_person_name:  cu.username, 
                            record_person:   cu.staffid ,
                            record_zone:       cu.dept_id, 
                            record_zone_name:     cu.dept_name 
                                   ).attributes
          end
        end.flatten
        StaffRecord.collection.insert(staff_records)
      end
      Trainee.scoped.map do | user |  
        TraineeRecord.new_record user.id, user.name,"","",cu.username,cu.staffid, cu.dept_id,cu.dept_name
      end
    end
  end

  def self.submit_everyday_records
    [StaffRecord , TraineeRecord].each do |item |
      item.where(attend_date: Date.today).state("registered").each{ |record|  record.submit }
    end
  end

end
