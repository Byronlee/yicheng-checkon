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
    render layout: false
  end
  
  def routing_error
    flash[:error]= "你所访问的url不存在！"
    render :error ,:layout => false
  end
  
  def browser_filter
    user_agent =  request.env['HTTP_USER_AGENT']
    return if user_agent.nil?
    user_agent = user_agent.downcase 
    @users_browser ||= begin
                         if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
                           'ie'+user_agent[user_agent.index('msie')+5].chr
                         elsif user_agent.index('gecko/')
                           'gecko'
                         elsif user_agent.index('opera')
                           'opera'
                         elsif user_agent.index('konqueror')
                           'konqueror'
                         elsif user_agent.index('ipod')
                           'ipod'
                         elsif user_agent.index('ipad')
                           'ipad'
                         elsif user_agent.index('iphone')
                           'iphone'
                         elsif user_agent.index('chrome/')
                           'chrome'
                         elsif user_agent.index('applewebkit/')
                           'safari'
                         elsif user_agent.index('googlebot/')
                           'googlebot'
                         elsif user_agent.index('msnbot')
                           'msnbot'
                         elsif user_agent.index('yahoo! slurp')
                           'yahoobot'
                         elsif user_agent.index('mozilla/')
                           'gecko'
                         else
                           'unknown'
                         end
                       end
    # ['chrome', 'gecko', 'safari']  只能chrome 浏览器使用！
    unless ['chrome'].include?(@users_browser)  then
      redirect_to browser_path
    end
  end


end
