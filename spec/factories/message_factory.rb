# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :message do
     launcher '123456'
     receiver '7890'
     checkins a: 1,b: 2
     record_id '123'
     remark '修改申请'  
  end
end
