# -*- coding: utf-8 -*-
module RecordsHelper

  def current_user
    @current_user
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

  def generate_selects default,select_name
    default = default || Behave.default.id
    str_over = Behave.all.inject("") do |str,behave|
      if behave.id == default 
        str << content_tag(:option,behave.name,selected: "selected",value: behave.id)
      else
        str << content_tag(:option,behave.name,value: behave.id)
      end
    end
    content_tag :select,str_over.html_safe,class: "span3",name: select_name
  end

  def generate_unit_selects user
    user.instance_variable_get(:@behaves).inject("") do |html_str,checkin|
      html_str << content_tag(:span ,checkin.check_unit.name+" : ")
      html_str << generate_selects(checkin.behave_id,"record[#{user.id}][#{checkin.check_unit_id}]")
    end
  end


  def register_or_modify type
    type=="finished" ? t("view.common.table_tasks_tr.registered") : t("view.common.table_tasks_tr.register")
  end
end
