# -*- coding: utf-8 -*-

require 'spec_helper'

describe Checkin do

  before(:each) do
    [ :forenoon, :afternoon ].each { |unit| create unit }
    @yesterday = create :yesterday_with_employee
  end

  it "生成一名员工的默认考勤登记数据" do
    @yesterday.create_checkins
    @yesterday.checkins.count.should == CheckUnit.all.count
  end
end
