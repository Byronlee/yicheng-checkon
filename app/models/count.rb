class Count
  include Mongoid::Document
  include Mongoid::Count

  class << self
    def create 
      types = BehaveType.find("517029571229bc9afb000005").behaves.map(&:_id)
      records = StaffRecord.state('submitted').by_period("2013-04-01","2013-04-19").in("checkins.behave_id"=> types)
      records.map_reduce(map,reduce).out(replace: "counts")
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
