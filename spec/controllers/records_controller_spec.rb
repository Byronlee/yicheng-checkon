# -*- coding: utf-8 -*-

require 'spec_helper'

describe RecordsController do

 describe "Get #index" do
    it "显示成功" do
      login
      get :index
      response.should be_success
    end

    it "应该看到所有考勤记录" do
      first:
      record = double('record')
      record.stub(:test).on_return('test')

      response.should
      expect do
        ...
      end.to from().to() || by()

      double == stub == mock
      double =  stub + mock
    end
  end

end
