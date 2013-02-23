# -*- coding: utf-8 -*-

require 'spec_helper'

describe Checkin do

  before(:each) do
    create :work
    [ :forenoon, :afternoon ].each { |unit| create unit }
    @yesterday = create :yesterday_with_employee
  end

  it "考勤记录创建时应默认生成基本考勤登记数据，所有考勤单元为一组" do
    @yesterday.checkins.count.should == CheckUnit.all.count
  end
end
