# -*- coding: utf-8 -*-
module DepartmentsHelper

  def unit_depts_selects object='condition',html_options = {class: "span9", onchange: "ajax_attend_tree($(this))"}
    if current_user.registrar?
      depts_select_instance object,current_user.depts_node,      html_options
    elsif current_user.approval?
      html_str =  depts_select_instance object,current_user.depts_node,html_options
      (1..2).inject(html_str){|html_str,_| html_str << depts_select_instance(object,[],html_options)}
    end
  end

  def depts_select_instance object,node = [],html_options={}
    depts_select object,"dept_id",node, {:prompt =>'--全部--'},html_options
  end

  def depts_select object,method,choices,options={},html_options={}
    content_tag :div,:class =>"input-prepend" do 
      content_tag(:span, content_tag(:i ,"" ,:class => "icon-home"), :class =>"add-on" )+
      select(object,method ,choices, options,html_options) 
    end
  end
end
