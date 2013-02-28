# -*- coding: utf-8 -*-
require 'spec_helper'

describe "考勤记录" do

  before :all do
    @yesterday = create :yesterday_with_employee
  end

  it "考勤记录生成后的初始状态应为checking" do
    @yesterday.state.should == 'checking'
  end

  it "考勤记录被登记后的状态应该为registered" do 
    @yesterday.register == true
    @yesterday.state.should == "registered"
  end

  it "考勤记录被提交后的状态应该为submited" do 
    @yesterday.submit == true
    @yesterday.state.should == "submited"
  end
end
