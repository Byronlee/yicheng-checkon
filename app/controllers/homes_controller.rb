# -*- coding: utf-8 -*-
class HomesController < ApplicationController

  skip_authorize_resource

  def index
    if current_user.registrar?
      return redirect_to registrar_path
    end
    if current_user.approval?
      return redirect_to approval_path
    end
    redirect_to cancan_error_path
  end

  
  def ajax_attend_tree 
    tree = $ACCESSOR.dept_tree(params[:dept_id])
    node=  $ACCESSOR.produce_tree_to_map tree
    if node[:children]
      choices =  node[:children].map{|v|[v[:name].strip , v[:id]]}
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
    ws_users =  $ACCESSOR.search_users(params[:term])
    suggestions = ws_users.map do |u|
       # TODO 搜索当前用户管辖的用户
      {value: u["SU_USER_ID"],text: u['SU_USERNAME']}
    end
    render :json => suggestions.to_json
  end
end
