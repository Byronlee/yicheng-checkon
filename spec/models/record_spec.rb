# -*- coding: utf-8 -*-
require 'spec_helper'

describe "考勤记录" do

  before :each do
    @yesterday = create :yesterday_with_employee
  end

  it "考勤记录生成后的初始状态应为checking" do
    @yesterday.state.should == 'checking'
  end
end
