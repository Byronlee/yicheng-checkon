# -*- coding: utf-8 -*-

require 'spec_helper'

describe RecordsController do

  describe "Get #index" do
     it "登录后会看到代办事务" do
        login 
        get :index
#        page.should have_content('伊诚考勤')
#        page.should have_content('代办事务')
        response.should be_success
     end
  end



  describe "数据操作" do
    before :each do
      @yesterday = create :yesterday_with_employee
      @yesterday.register
    end

    it  "默认显示登录用户可以看见的所有数据" do
      get :operate
      assigns(:records).map {|x| x.should == @yesterday }
      response.should be_success
    end


    it "根据选择条件进行搜索" do 
      post :query , {start_time: "2013-04-05",end_time: "2013-04-05" ,region_id: nil,cell_id: nil ,dept_id: @yesterday.record_zone }
      assigns(:result).should_not be_empty
      assigns(:result).map {|x| x.should == @yesterday } 
      response.should be_success
    end

  end

end
