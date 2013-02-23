# -*- coding: utf-8 -*-

require 'spec_helper'

describe CheckUnit do

  before(:each) do
    [ :forenoon, :afternoon ].each { |unit| create unit }
  end

  it "所有考勤单元的系数累加应当为考勤基数" do
    CheckUnit.all.map(&:ratio).inject(&:+).should == CheckUnit.BASE
  end
end
