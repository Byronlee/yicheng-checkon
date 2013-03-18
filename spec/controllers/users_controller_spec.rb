# -*- coding: utf-8 -*-

require 'spec_helper'

describe UsersController do
  before :each do 
    @no_number_employee = create(:no_number_employee)
  end
  
  it "显示无工号员工列表" do
    get :index
    assigns(:users).should include(@no_number_employee)
    response.should render_template(action: "index")
  end

  it "添加新的无工号员工" do
    post :create ,user: attributes_for(:no_number_employee)
    assigns(:user).username.should == @no_number_employee.username
    response.should render_template(action: "show")
  end
end
