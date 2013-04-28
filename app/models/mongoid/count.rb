# -*- coding: utf-8 -*-
module Mongoid
  module Count
    extend ActiveSupport::Concern

    module  ClassMethods 
      def map
        map = %Q{
        function() {
          for (var checkin in this.checkins){
            emit({"behave_id": this.checkins[checkin].behave_id,"user_id": this.staffid}, this);
          }
        }
        }
      end

      def finalize
        %Q{
        function(key, values) {
          if(!values.count){
            return  {count: 1 , records: [values]}
            }
          return  values;
          }
        }
      end

      def reduce
        reduce = %Q{
        function(key, values) {
           return {count: values.length , records: values};
        }
        }
      end


      def default_count_behave_types
        Settings.count_types.map do |type,behaves|
          behaves.map do |behave,name|
            Behave.find_by(name: name).id
          end
        end.flatten
      end
      
      def export start,over,user_ids
        new_book = Spreadsheet::Workbook.new 
        worksheet_name = start+'_'+over+'_'+Settings.exel_worksheet_name
        new_book.create_worksheet :name => worksheet_name
        new_book.worksheet(0).insert_row(0, Settings.exel_header)
        records = select_records start,over,user_ids
        counts  = excute_counts(records)
        counts.each_with_index do |x,index|
          user = User.resource(x["_id"]["user_id"])
          behave_name = Behave.find(x["_id"]["behave_id"]).name  
          new_book.worksheet(0).insert_row(index+1,[user.ancestors,user.user_no,user.username,behave_name,x["value"]["count"]*0.5])
        end
        write_file new_book,start,over
      end

      def write_file new_book,start,over
        message = {}
        Dir.mkdir(Settings.export_path) unless File.exist?(Settings.export_path)
        file_name = start+'_'+over+'_'+Time.now.to_i.to_s+"_count.xls"
        if new_book.write(Settings.export_path + file_name)
          message[:state] = 1
          message[:notice] = '成功导出，请点击下载'
          message[:url] = "/exels/"<< file_name
        else
          message[:state] = 0
          message[:notice] = '导出失败，请稍后在试'
        end
        message
      end

    end
  end
end
