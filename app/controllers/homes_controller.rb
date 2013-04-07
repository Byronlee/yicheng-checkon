# -*- coding: utf-8 -*-
class HomesController < ApplicationController

  skip_authorize_resource

  def index
    if current_user.registrar?
      redirect_to registrar_path
    end
    if current_user.approval?
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

  private 
    def next_node node
      node.eql?("cell") ? "dept" : ""
    end
end
