# -*- coding: utf-8 -*-

require 'spec_helper'

describe RecordsController do

 
  it "请求index,得到每天需要考勤的部门或小组" do
    login 
    get :index 
    response.should be_success 
  end
  
  it "注册新记录" do
    get :new
  end


end
