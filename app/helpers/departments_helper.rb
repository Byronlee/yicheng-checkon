# -*- coding: utf-8 -*-
module DepartmentsHelper



  def unit_depts_selects 
    if current_user.registrar?
      depts_select_instance current_user.depts_node
    elsif current_user.approval?
      html_str =  depts_select_instance current_user.depts_node
      (1..2).inject(html_str){|html_str,_| html_str << depts_select_instance }
    end
  end

  def depts_select_instance node = []
    depts_select "condition","dept",node, {:prompt =>'--全部--'},{class: "span10", onchange: "ajax_attend_tree($(this))"}
  end

  def depts_select object,method,choices,options={},html_options={}
    content_tag :div,:class =>"input-prepend" do 
      content_tag(:span, content_tag(:i ,"" ,:class => "icon-home"), :class =>"add-on" )+
      select(object,method ,choices, options,html_options) 
    end
  end

end
