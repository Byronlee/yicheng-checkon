# -*- coding: utf-8 -*-
class Count
  include Mongoid::Document
  include Mongoid::Count

  class << self
    def create params      
      behave_ids =  BehaveType.find("517029571229bc9afb000005").behaves.map(&:_id)                  
      @total_records  = StaffRecord.state('submitted').by_period(params[:start_time],params[:end_time])                 
      @count_records = @total_records.in("checkins.behave_id" => behave_ids)
      hh=  @count_records.map_reduce(map,reduce).out(replace: "counts")
    end
  end

  def behave_name
    Behave.find(id["behave_id"]).name
  end

  def user
    User.resource(id["user_id"])
  end

  def records
    value["record_ids"].uniq.map do |record_id|
      StaffRecord.find(record_id)
    end.flatten
  end
end
