# -*- coding: utf-8 -*-
module StaffRecordsHelper


  def unit_selects cins,name
    cins.inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << behaves_select(checkin,{},{name: "#{name}[#{checkin.check_unit_id}]",class:"span3"})
    end
  end

  def behaves_select object, options={},html_options={}
    @checkin  = object
    select("checkin","behave_id",behaves,options,html_options)
  end

  def behaves
    Behave.all.collect{|b|[b.name,b.id]}
  end



  def show_query_recors_reulst_table_titles
    ["所在位置" ," 员工工号" , "职位" , "姓名", "昵称" ," 登记人" , "上午考勤" , "下午考勤" , "考勤日期" , "操作"]
  end


  def register_or_modify state
    state=="registered" ? t('.registered') : t('.register')
  end

  def btn_name state
    state.eql?("registered") ? "修改" : "保存"
  end

  def modify_button
    return "修改考勤" if  current_user.approval? 
    "申请修改"
  end

end
