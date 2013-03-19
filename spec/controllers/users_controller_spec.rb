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

  it "通过部门id异步获取该部门的所有员工" do
    department = Department.new("4028809b3c6fbaa7013c6fbc39900380")
    get :ajax_user_select,dept_id: department.id
    response.should be_success
  end

  it "将无工号员工进行合并" do
    get :merge,o_id: @no_number_employee.id,n_id: "222"
    assigns(:result).should be_true
    response.should render_template(action: "index")
  end
end
