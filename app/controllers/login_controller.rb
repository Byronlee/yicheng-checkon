class LoginController < ApplicationController
  def index
  end

  def login
    if(params["auth_key"]=="123")
      redirect_to "/person/index"
    elsif(params["auth_key"]=="1234")
      redirect_to "/person/stores_index"
    elsif (params["auth_key"]=="12345")
      redirect_to "/person/minister_view"
    else redirect_to "/login/login"
    end
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
