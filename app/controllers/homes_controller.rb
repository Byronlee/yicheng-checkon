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

  def browser
   render layout: false
  end

  def ajax_attend_tree 
    node = Webservice.get_data "dept_tree/"+params[:dept_id]
    if node["children"]
      choices =  node["children"].map{|v| [v["name"] , v["id"]]}
      render "common/_organization_select",locals: {object:"condition",ayout => false}
    else
      render :json => false
    end
  end

end
