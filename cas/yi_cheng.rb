# -*- coding: utf-8 -*-

$YICHENG_WS_PATH="/data/projects/yicheng-checkon"
require "#{$YICHENG_WS_PATH}/web_service/org_stru"


class CASServer::Authenticators::YiCheng < CASServer::Authenticators::Base
  def validate(credentials)
    read_standard_credentials(credentials)
    orgstru = OrgStru.new 
    user = orgstru.user(@username)  
    raise CASServer::AuthenticatorError, "Username is not exist!" if user.nil? or user.empty?

    user_id = user["SU_USER_ID"]
    roles = []
    roles << "Registrar" if orgstru.registrar? user_id
    roles << "Approval" if orgstru.approval? user_id
    user["roles"] = roles 

    @extra_attributes[:attrs] = user 
    
    return @password == @username
  end
end
