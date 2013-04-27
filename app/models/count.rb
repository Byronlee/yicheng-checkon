# -*- coding: utf-8 -*-
class Count
  include Mongoid::Document
  include Mongoid::Count
 
  class << self

    def select_records start,over,user_ids
      @records = StaffRecord.by_period(start,over).state('submitted') 
      @records = @records.in(staffid: user_ids) unless user_ids.blank?
      @records.in("checkins.behave_id" => default_count_behave_types ) 
    end


   def excute_counts records
     Count.new(records.map_reduce(map,reduce).out(inline: 1).finalize(finalize).raw)
   end


  

   def package_counts counts, result={},tmp = {}
     Settings.count_types.map do |type,behaves|
        behaves.map do |behave,name|
         behave_id = Behave.find_by(name: name).id
         tmp[behave] = counts.where("_id" =>  1)
       end
       result[type] = tmp
       tmp = {}
     end
      result
   end
  end  # class << self

  def behave_name
    Behave.find(id["behave_id"]).name
  end

  def user
    records.first.user
  end

  def records
    value["records"].uniq.map{ |record| StaffRecord.new(record)}.flatten
  end
end
