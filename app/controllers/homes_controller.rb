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
    # 当我不是已这两个角色登录 没有处理
  end

  def browser
   render layout: false
  end

  def ajax_attend_tree 
    node = Webservice.get_data "dept_tree/"+params[:dept_id]
    if node["children"]
      choices =  node["children"].map{|v| [v["name"] , v["id"]]}
      render "common/_organization_select",locals: {object:"condition",node: choices,html_options: {}},:layout => false
    else
      render :json => false
    end
  end

  def ajax_dept_users
    users = !params[:dept_id].empty? ? Department.new(params[:dept_id]).users_select : []
    render "common/_user_select",locals:{choices: users},:layout => false
  end

  def search_users
    ws_users = Webservice.search_users(params[:query])
    suggestions = ws_users.map do |u|
      {value: u['SU_USERNAME'], data: u["SU_USER_ID"]}
    end
    render :json => {query: params[:query],suggestions: suggestions}
  end
end
