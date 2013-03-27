# -*- coding: utf-8 -*-
class Crontask 

   def self.produce_everyday_records cu=User.current_user
      cu.attend_depts["children"].map do | dept | 
      Department.new(dept["id"]).users.map do | user |
        new_record(user.staffid, 
                   user.username,
                   user.user_no ,
                   user.nickname_display,
                   cu.username, 
                   cu.id ,
                   cu.dept_id, 
                   cu.dept_name )
      end
    end
    User.scoped.map do | user |
       new_record u, Date.today, cu.username,cu.dept_name
    end

  end


  def self.submit_everyday_records
    [StaffRecord , TraineeRecord].where(attend_date: Date.today).state("registered").each{ |record|  record.submit }
  end

end
