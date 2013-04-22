# -*- coding: utf-8 -*-
class Count
  include Mongoid::Document
  include Mongoid::Count
 

  class << self
    def create params      
        @total_records = StaffRecord.by_period(params[:start_time],params[:end_time]).state('submitted')                 
        @count_records = @total_records.in("checkins.behave_id" => default_count_behave_types )      
        @count_records.map_reduce(map,reduce).out(replace: "counts").count
    end


    def default_count_behave_types
      Settings.default_count_behave_types.inject([]) do |types,type_name |
        types << BehaveType.find_by(name: type_name).behaves.map(&:_id)
      end.flatten
    end

    def counts current_user     
       {leave:        count_result(current_user,Settings.leave_behave_ids),
        absent:       count_result(current_user,Settings.behave_absent_id) ,
        late:         count_result(current_user,Settings.behave_late_id) ,
        away:         count_result(current_user,Settings.behave_away_id) ,
        leave_die:    count_result(current_user,Settings.behave_leave_die_id) ,
        leave_sick:   count_result(current_user,Settings.behave_leave_sick_id),
        leave_marry:  count_result(current_user,Settings.behave_leave_marry_id),
        leave_thing:  count_result(current_user,Settings.behave_leave_thing_id),
        leave_preg:   count_result(current_user,Settings.behave_leave_preg_id)}
    end
  end

  def behave_name
    Behave.find(id["behave_id"]).name
  end

  def user
    User.resource(id["user_id"])
  end

  def records
    value["record_ids"].uniq.map{ |record_id| StaffRecord.find(record_id)}.flatten
  end

end
