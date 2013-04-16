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

  def hook
   # push = JSON.parse(params[:payload])
   p "____________________push to github________________________"

   path = Rails.root
   if system("cd #{path} & git pull origin master")
     render :json => "git pull origin master successfully"
   else
     render :json => "git pull origin master unsuccessfully"
   end
  end
end
