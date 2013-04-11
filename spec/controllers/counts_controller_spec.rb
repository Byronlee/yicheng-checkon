# -*- coding: utf-8 -*-

require 'spec_helper'

describe CountsController do

  before :each do
    @record = create_list :yesterday_with_employee,2
  end

  it "没有任何统计数据" do
    assigns(:stats).should be_nil
  end

  it "有数据" do
    @record.each {|x|x.register}
    get :index
    [:user_no,:username,:behaves].each do |k|
#     assigns(:stats).first.should have_key(k)
    end
  end
end
