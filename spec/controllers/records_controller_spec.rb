# -*- coding: utf-8 -*-

require 'spec_helper'

describe RecordsController do

 describe "Get #index" do
    it "显示成功" do
      login
      p "++++++++++++++"
      p session["admin"]
      get :index
      response.should be_success
    end

    it "应该看到所有考勤记录" do
    end
  end

end
