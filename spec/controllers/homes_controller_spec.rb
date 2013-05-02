# -*- coding: utf-8 -*-
require 'spec_helper'

describe HomesController do

  context "GET #index" do
    it "my role includes *Regitstrar* when login as a registrar" do
      registrar_login
      get :index
      controller.current_user.roles.should include('Registrar')
      assert_redirected_to '/registrar'
    end

    it "my role includes *Rightsman* when login as a registrar" do
      registrar_login
      get :index
      controller.current_user.roles.should include('Rightsman')
      assert_redirected_to '/registrar'
    end

    it "my role includes *Approval* when login as a approval" do
      approval_login
      get :index
      controller.current_user.roles.should include('Approval')
      assert_redirected_to '/approval'
    end

    it "have no role when login as a staff" do
      no_role_login
      get :index
      controller.current_user.roles.should == []
      assert_redirected_to '/cancan_error'
    end
  end
end
