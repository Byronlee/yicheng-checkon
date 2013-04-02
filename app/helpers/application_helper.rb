# -*- coding: utf-8 -*-
module ApplicationHelper

 def available? var
   var.empty?  ? nil : var  if var
 end

 
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
end
