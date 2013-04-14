# -*- coding: utf-8 -*-
module ApplicationHelper
 
 def current_user
    User.current_user
 end

 def query_dept_tree
   current_user.registrar? ? registrar_attend_tree : approval_attend_tree
 end

 def approval_attend_tree
   {region: {type: "region" , 
            options: node_depts ,
            tips: "--全部--",
            next_node: "cell"},
     cell: {type: "cell" , 
            options: [],
            tips: "--全部--",
            next_node: "dept"},
     dept: {type: "dept" , 
            options: [],
            tips: "--全部--",
            next_node: ""}}

  end

 def registrar_attend_tree
   {region: [],
     cell:  [],
     dept: {type: "dept" , 
            options: node_depts ,
            tips: "--全部--" ,
            next_node: ""} }
 end

 def node_depts
   children = current_user.roles.attend_depts["children"]
   if children then 
     children.map{|v| [v["name"] , v["id"]]}
   else
     []
   end 
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
