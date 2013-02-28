# -*- coding: utf-8 -*-

require 'spec_helper'

describe "考勤数据" do

  before(:each) do
    [:work , :sick_leave, :forenoon, :afternoon ].each { |unit| create unit }
    @yesterday = create :yesterday_with_employee
  end

  it "考勤记录创建时应默认生成基本考勤登记数据，所有考勤单元为一组" do
    @yesterday.checkins.count.should == CheckUnit.all.count
  end

  it "初建的考勤数据中，行为都应当是默认行为" do
    @yesterday.checkins.each do |checkin|
      checkin.behave.should == Behave.default
    end
  end
end

