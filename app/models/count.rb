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
        types << BehaveType.behave_ids_by_name(type_name)
      end.flatten
    end

    def counts      
       {leave:        self.in("_id.behave_id"  => convert_object(BehaveType.behave_ids_by_name('请假'))),
        absent:       count_result(Behave.find_by(name: '旷工').id),
        late:         count_result(Behave.find_by(name: '迟到').id),
        away:         count_result(Behave.find_by(name: '离职').id),
        leave_die:    count_result(Behave.find_by(name: '丧假').id),
        leave_sick:   count_result(Behave.find_by(name: '病假').id),
        leave_marry:  count_result(Behave.find_by(name: '婚假').id),
        leave_thing:  count_result(Behave.find_by(name: '事假').id),
        leave_preg:   count_result(Behave.find_by(name: '产假').id),
       }
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
