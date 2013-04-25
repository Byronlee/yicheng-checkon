# -*- coding: utf-8 -*-
module Mongoid
  module Count
    extend ActiveSupport::Concern

    module  ClassMethods 
      def map
        map = %Q{
        function() {
          for (var checkin in this.checkins){
            emit({"behave_id": this.checkins[checkin].behave_id,"user_id": this.staffid}, this._id);
          }
        }
        }
      end

      def finalize
        %Q{
        function(key, values) {
          if(!values.count){
            return  {count: 1 , record_ids: [values]}
            }
          return  values;
          }
        }
      end

      def reduce
        reduce = %Q{
        function(key, values) {
           return {count: values.length , record_ids: values};
        }
        }
      end

      def export 
        new_book = Spreadsheet::Workbook.new 
        new_book.create_worksheet :name => Settings.exel_worksheet_name
        new_book.worksheet(0).insert_row(0, Settings.exel_header)
        self.all.each_with_index do |x,index|
          new_book.worksheet(0).insert_row(index+1,[x.user.ancestors,x.user.user_no,x.user.username,x.behave_name,x.value["count"]*0.5])
        end
        write_file new_book
      end

      def write_file new_book
        message = {}
        if File.directory?(Settings.export_path)
          suffix_path = Time.now.strftime("%FT%R")+"_count.xls"
          if new_book.write(Settings.export_path + suffix_path)
            message[:state] = 1
            message[:notice] = '成功导出，请点击下载'
            message[:url] = "/exels/" <<suffix_path
          else
            message[:state] = 0
            message[:notice] = '导出失败，请稍后在试'
          end
        else
          message[:state] = 0
          message[:notice] = Settings.export_path + '目录不存在'
        end
      message
      end

    end
  end
end
