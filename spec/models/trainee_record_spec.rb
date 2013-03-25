# -*- coding: utf-8 -*-
require 'spec_helper'

describe "TraineeRecord" do

  before :each do
    @no_number_user = create :no_number_employee
    @record = TraineeRecord.trainee_everyday_records
  end

  describe "初始化无工号员工的考勤数据" do 
    it "属于no_number_user" do
      @record.first.user_id.should == @no_number_user.id
    end

    it "条数为计薪时间到现在的天数" do
    # @record.first.should == @no_number_user.initialized_days
    end
  end

  describe "合并无工号员工的考勤数据" do
    before :each do
      @default_record = create :yesterday_with_employee
      @result = TraineeRecord.merge @no_number_user.id,@default_record.staffid
    end

    it "这时User中没有此无工号员工信息" do
    User.where(_id: @no_number_user.id).first.should be_nil
    end

    it "这时Record中包含合并的数据" do
     TraineeRecord.find_by(user_id: @no_number_user.id).should_not be_nil
    end
  end
end
