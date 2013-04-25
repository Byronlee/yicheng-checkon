# -*- coding: utf-8 -*-
class StaffRecord
  include Mongoid::Record

  has_many :modifies

  index({ staffid: 1})
  class << self
    def by_period first,last  
      between(created_date: [first,last])
    end

    def by_day time
      between(created_date: [time.end_of_day,time.beginning_of_day])
    end

    def fast_register arg ,current_user
      Department.new(arg[:dept_id]).users.map do | user |
        record = get_record user.staffid,arg[:time]
        record.checkins.update_all(behave_id: arg[:behave_id])
        record.update_attribute(:attend_date,Date.today)
        record.update_attribute(:record_person,current_user.staffid)
        record.register
      end
    end

    def by_behave_id behave_id
      where('checkins.behave_id' => Moped::BSON::ObjectId.from_string(behave_id))
    end

    def by_staffid staffid
      where(staffid: staffid)
    end

    def direct_update args ,current_user
      record = find(args[:staff_record_id])
      record.update_checkins(args[:checkins])
    end
  
    def trainee_register arg ,current_user
      TraineeRecord.register arg
    end

    def staffs current_user
      # 得到一个文员当天的考勤任务(包括已完成的) 且还没有提交的
      unique self.in(staffid: current_user.users_with_subdept).in(state: ["checking","registered"])
    end

    def unique records
      if records
        tasks = records.map do | record |
          user =  User.resource(record.staffid)
        { dept_id: user.dept_id, 
          created_at: record.created_date,
          dept_name: user.dept_name ,
          state: record.state
        }
        end
        tasks.uniq.sort_by! do |item|
          [item[:state] ,item[:dept_name]]
        end
      end
    end
  end  # class << self

   def change? checks
     bool = checks.map do |check_unit_id,behave_id|
       checkins.find_by(check_unit_id: check_unit_id).behave_id.to_s.eql?(behave_id)
     end
     bool.all? ? false : true
   end
end
