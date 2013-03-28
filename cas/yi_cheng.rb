# -*- coding: utf-8 -*-

$YICHENG_WS_PATH="#{File.dirname(__FILE__)}"
require "#{$YICHENG_WS_PATH}/../web_service/access_oracle"


class CASServer::Authenticators::YiCheng < CASServer::Authenticators::Base
  def validate(credentials)
    read_standard_credentials(credentials)
    orgstru = OrgStru.new 
    user = orgstru.user(@username)  

    raise CASServer::AuthenticatorError, "Username is not exist!" if user.nil? or user.empty?
    user_id = user["SU_USER_ID"]
    ext_attrs = orgstru.user_attr_ext (user)
    
    role = []
    role << "Registrar" if orgstru.registrar? user_id
    role << "Approval" if orgstru.approval? user_id
    
    user["role"] = role 
    user.merge! ext_attrs
    @extra_attributes[:attrs] = user 
    
    return @password == @username
  end
end
