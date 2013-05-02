# -*- coding: utf-8 -*-
class ExceptionsController < ActionController::Base

  def browser_error
   render layout: false
  end

  def render_404
    flash[:error]= "你所访问的资源不存在！"
    render :error , :layout => false
  end
  
  def routing_error
    flash[:error]= "你所访问的url不存在！"
    render :error ,:layout => false
  end

  def cancan_error
    flash[:error]= "你无权限访问此页面！"
    render :error ,:layout => false
  end
end
