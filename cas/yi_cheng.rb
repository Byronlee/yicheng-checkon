# -*- coding: utf-8 -*-

$YICHENG_WS_PATH="#{File.dirname(__FILE__)}"
require "#{$YICHENG_WS_PATH}/lib/access_oracle"


class CASServer::Authenticators::YiCheng < CASServer::Authenticators::Base
  def validate(credentials)
    read_standard_credentials(credentials)

    user = OrgStru.new.user(@username)  

    raise CASServer::AuthenticatorError, "Username is not exist!" if user.empty?

    @extra_attributes[:attrs] = user  

    return @password == @username
  end
end
