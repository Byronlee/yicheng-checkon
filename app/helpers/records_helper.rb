# -*- coding: utf-8 -*-
module RecordsHelper

  def current_user
    @current_user
  end

  def query_dept_tree
    {region: [],
     cell: [],
     dept: {type: "dept" , 
            options: current_user.attend_depts["children"].map{|v| [v["name"] , v["id"]]} ,
            tips: "--全部--" } }
  end

  def FormatDate time
    case (Time.now.to_date - time.to_date)
    when 0
      t("helper.records.today")
    when 1
      t("helper.records.yesterday")
    when 2
      t("helper.records.before_yesterday")
    else
      time
    end
  end


  def unit_selects user
    user.instance_variable_get(:@cins).inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << behave_selects(checkin,{},{name: "record[#{user.staffid}][#{checkin.check_unit_id}]",class:"span3"})
    end
  end

  def no_number_selects record
#   debugger
    record.checkins.inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << behave_selects(checkin,{},{name: "record[#{record.user_id}][#{checkin.check_unit_id}]",class:"span3"})
    end
  end


  
  def show_query_recors_reulst_table_titles
    ["所在位置" ," 员工工号" , "职位" , "姓名", "昵称" ," 登记人" , "上午考勤" , "下午考勤" , "考勤日期" , "操作"]
  end

 


  def register_or_modify type
    type=="finished" ? t("view.common.table_tasks_tr.registered") : t("view.common.table_tasks_tr.register")
  end

  def behave_selects checkin,options = {}, html_options = {}
    @checkin = checkin 
    behaves = Behave.all.collect{|b|[b.name,b.id]}
    select("checkin","behave_id",behaves,options,html_options)
  end

  def depts
    depts = current_user.attend_depts["children"].map{|v| [v["name"] , v["id"]]}
  end
  
  def organization_selects(depts,options = {}, html_options = {})
    select("dept","dept_id",depts,options,html_options)
  end

  def btn_name s
    s == "registered" ? "修改" : "保存"
  end

end
