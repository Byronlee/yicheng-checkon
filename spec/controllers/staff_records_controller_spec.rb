# -*- coding: utf-8 -*-

require 'spec_helper'
describe StaffRecordsController do

  context "Get #index" do
    before :each do
      registrar_login
      get :index
      @records = create_list(:staff_record,21)
      @records.map{|x|x.register && x.submit}

    end

    it "the state of every record should be submitted" do
      @records.map(&:submitted?).all?.should be_true
    end

    it "the number of records should be less than 20" do
      assigns(:records).count.should <=20
      response.should be_success
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(response).to render_template("index")
    end
  end



end
