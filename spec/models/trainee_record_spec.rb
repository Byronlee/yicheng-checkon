# -*- coding: utf-8 -*-
require 'spec_helper'

describe TraineeRecord do

  describe "合并无工号员工的考勤数据" do
    before :each do
      @user = User.current_user = create :user
      @trainee = create :trainee
      TraineeRecord.merge @trainee.id,@user.staffid
    end

    it "这时Trainee中没有此无工号员工信息" do
      Trainee.where(id: @trainee.id).should be_empty
    end

    it "这时Trainee Record中包含合并的数据" do
      TraineeRecord.where(staffid: @trainee.id).should be_empty
    end

    it "这时staff Record中包含合并的数据" do
      StaffRecord.where(staffid: @user.staffid).map(&:staff_name).uniq.should == [@trainee.username]
    end
  end
end
