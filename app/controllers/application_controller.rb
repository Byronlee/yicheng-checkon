# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :browser_filter unless Rails.env.test?
  before_filter CASClient::Frameworks::Rails::Filter

  authorize_resource
  skip_authorize_resource :only => :logout

  helper_method :current_user

  def current_user
    attrs = session[:cas_extra_attributes]["attrs"]
    User.resource(attrs["SU_USER_ID"]).perssion(attrs["roles"])
  end 

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
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
    unless ['chrome', 'gecko', 'safari'].include?(@users_browser)  then
      redirect_to browser_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url , :alert => exception.message
  end
end
