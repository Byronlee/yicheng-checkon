# -*- coding: utf-8 -*-
class  ApplicationWithExceptionsController < ActionController::Base
  # 异常种类：
  # rescue_from ActionController::UnknownController 
  # rescue_from AbstractController::ActionNotFound
  # rescue_from NoMethodError
  # rescue_from RuntimeError
  # rescue_from Mongoid::Errors::DocumentNotFound
  # rescue_from Mongoid::Errors::Validations
  # rescue_from Moped::Errors::OperationFailure
  # rescue_from NameError
  # rescue_from CanCan::AccessDenied
  
  rescue_from Exception do | exception|
    flash[:error]=  exception.message
    render :error , :layout => false
  end
  
  def browser_error
    @user_agent = UserAgentParser.parse(request.user_agent)
    render layout: false
  end
  
  def routing_error
    flash[:error]= "你所访问的url不存在！"
    render :error ,:layout => false
  end
  
  def browser_filter
    @user_agent = UserAgentParser.parse(request.user_agent)
    p '_______________'
    p @user_agent
    p @user_agent.name
    p @user_agent.version
    p @user_agent.os
    return if @user_agent.nil? 
    name = @user_agent.name.downcase
    if ['chrome','safari','firefox','opera','sogou explorer','maxthon','ie'].include?(name)  then
      return redirect_to browser_path if name.eql?('ie') && @user_agent.version.major.to_i < 10
    else
     return redirect_to browser_path
    end
  end
end
