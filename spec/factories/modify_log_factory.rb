# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :modify_record do

    factory :apply_data  do 
      raw_behave "全勤"
      apply_user  (Webservice.get_data "checkers")[0] 
      latest_behave "迟到"
      apply_reason "打错"
    end

    factory :approval_data_pass  do 
      approval_user  (Webservice.get_data "checkers")[0] 
      approval_date  Date.today.to_s
      approval_remark "通过"
      state   "pass"
    end

    factory :approval_data_refuse  do 
      approval_user  (Webservice.get_data "checkers")[0] 
      approval_date  Date.today.to_s
      approval_remark "拒绝"
      state   "refuse"
    end


  end
end
