# -*- coding: utf-8 -*-

require 'spec_helper'

describe "用户数据" do
  
 
  before(:all) do
   @user = User.new("4028809b3c6fbaa7013c6fbc3db41bc3")
  end

  it "用户职状态应该为在职" do
    @user.status.should == "在职"
  end

  it "通过用户id和webservice返回他所能考勤的部门" do
    @user.attend_depts.count.should ==  (Webservice.getData("/attend/tree/"+@user.id)).count
  end

end

