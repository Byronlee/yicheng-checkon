# -*- coding: utf-8 -*-
class Count
  include Mongoid::Document
  include Mongoid::Count
 
  class << self
    def create params      
        @total_records = StaffRecord.by_period(params[:start_time],params[:end_time]).state('submitted')                 
        @count_records = @total_records.in("checkins.behave_id" => default_count_behave_types )      
        @count_records.map_reduce(map,reduce).out(replace: "counts").finalize(finalize).count
    end

    def default_count_behave_types
      Settings.count_types.map do |type,behaves|
        behaves.map do |behave,name|
          Behave.find_by(name: name).id
        end
      end.flatten
    end

    def counts  current_user,result={},tmp = {}
      Settings.count_types.map do |type,behaves|
        behaves.map do |behave,name|
          behave_id = Behave.find_by(name: name).id
          tmp[behave] = current_user.counts_result(behave_id)
        end
        result[type] = tmp
        tmp = {}
      end
      result
    end

    def export 
      new_book = Spreadsheet::Workbook.new 
      new_book.create_worksheet :name => '伊诚考勤统计表'
      new_book.worksheet(0).insert_row(0, Settings.exel_header)
      Count.all.each_with_index do |x,index|
        new_book.worksheet(0).insert_row(index+1,[x.user.ancestors,x.user.user_no,x.user.username,x.behave_name,x.value["count"]*0.5])
      end
      new_book.write(Rails.root + 'public/exels/count.xls')
    end

    def by_behave_id behave_id
      where("_id.behave_id"  => behave_id)
    end

  end  # class << self

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
