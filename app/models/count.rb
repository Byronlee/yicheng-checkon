# -*- coding: utf-8 -*-
class Count
  include Mongoid::Document
  include Mongoid::Count

  class << self

    def create start,over,user_ids
      records = select_records start,over,user_ids
      counts  = excute_counts(records)
      package_counts(counts)    
    end


    def select_records start,over,user_ids
      @records = StaffRecord.by_period(start,over).state('submitted') 
      @records = @records.in(staffid: user_ids) unless user_ids.blank?
      @records = @records.in("checkins.behave_id" => default_count_behave_types ) 
    end

    def excute_counts records
      records = records.map_reduce(map,reduce).finalize(finalize).out(inline: 1).send(:documents)
      # 去掉除默认考勤项以为的考勤项
      records.select{|x|default_count_behave_types.include?(x["_id"]["behave_id"])}
    end

    def package_counts counts, result={},tmp = {}
      Settings.count_types.map do |type,behaves|
        behaves.map do |behave,name|
          behave_id = Behave.find_by(name: name).id
          tmp[behave] = counts.select{|x|x['_id']['behave_id'].eql?(behave_id)}
        end
        result[type] = tmp
        tmp = {}
      end
      result
    end
  end  # class << self
end
