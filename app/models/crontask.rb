# -*- coding: utf-8 -*-
class Crontask 
   def self.staff_everyday_records 
    current_user =  User.current_user
    current_user.attend_depts["children"].map do | dept | 
      Department.new(dept["id"]).users.map do | user |
      # 如果将考勤权限交给其他文员,将会出现重复初始化数据的bug
        new_record(user.staffid  ,        user.username,          user.user_no ,
                          user.nickname_display, current_user.username,  current_user.id  ,
                          current_user.dept_id,  current_user.dept_name )
      end
    end
  end


  def self.trainee_everyday_records
    users = User.scoped
    users.map do | u |
      new_record u.id,u.username,Date.today,u.user_no,"","",User.current_user.username,"","meili"
    end
  end


end
