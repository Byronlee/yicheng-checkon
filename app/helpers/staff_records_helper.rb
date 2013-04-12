# -*- coding: utf-8 -*-
module StaffRecordsHelper


  def unit_selects cins,name
    cins.inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << behave_selects(checkin,{},{name: "#{name}[#{checkin.staff_record.staffid}][#{checkin.check_unit_id}]",class:"span3"})
    end
  end

  def behave_selects checkin,options = {}, html_options = {}
    @checkin = checkin
    behaves = Behave.all.collect{|b|[b.name,b.id]}
    select("checkin","behave_id",behaves,options,html_options)
  end


  def no_number_selects record
    record.checkins.inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << behave_selects(checkin,{},{name: "record[#{record.trainee_id}][#{checkin.check_unit_id}]",class:"span3"})
    end
  end



  def show_query_recors_reulst_table_titles
    ["所在位置" ," 员工工号" , "职位" , "姓名", "昵称" ," 登记人" , "上午考勤" , "下午考勤" , "考勤日期" , "操作"]
  end


  def register_or_modify state
    state=="registered" ? t("view.common.table_tasks_tr.registered") : t("view.common.table_tasks_tr.register")
  end

  def btn_name state
    state.eql?("registered") ? "修改" : "保存"
  end

end
