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
            tips: "--选择店组--" } }
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

  def generate_selects default=nil ,select_name = nil , class_name=nil
    default = default || Behave.default.id
    str_over = Behave.all.inject("") do |str,behave|
      if behave.id == default 
        str << content_tag(:option,behave.name,selected: "selected",value: behave.id)
      else
        str << content_tag(:option,behave.name,value: behave.id)
      end
    end
    content_tag :select,str_over.html_safe,name: select_name, class: class_name , field: "behave_id" , order: "false"
  end

  def generate_unit_selects user
    user.instance_variable_get(:@behaves).inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << generate_selects(checkin.behave_id,"record[#{user.staffid}][#{checkin.check_unit_id}]" ,"span3")
    end
  end


  def full_attr record
     user = User.resource(record.staffid)
     ["" ,user.user_no , "" ]
  end


  def show_query_recors_reulst_table_titles
    ["所在位置" ," 员工工号" , "职位" , " 登记人" , "上午考勤" , "下午考勤" , "考勤日期" , "操作"]
  end

  def register_or_modify type
    type=="finished" ? t("view.common.table_tasks_tr.registered") : t("view.common.table_tasks_tr.register")
  end
end
