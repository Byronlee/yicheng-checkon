# -*- coding: utf-8 -*-
class HomesController < ApplicationController


  def index
    case  current_user.role.first
    when 'Registrar'
      redirect_to registrar_path
    when 'Approval'
      redirect_to approval_path
    end
  end



  def ajax_attend_tree 
    node = Webservice.get_data "dept_tree/"+params[:dept_id]
    node_type =["region" ,""]
    if node["children"]
      select = { type: params[:type] ,
                 options: node["children"].map{|v| [v["name"] , v["id"]]} ,
                 tips: "--全部--",
                 next_node: next_node(params[:type])}
      render "common/_organization_select",locals: {select: select },:layout => false
    else
      render :json => false
    end
  end

   def next_node node
     node.eql?("cell") ? "dept" : ""
   end
end
