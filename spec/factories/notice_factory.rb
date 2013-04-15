# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :notice do
     launcher '123456'
     receiver '7890'
     factory :flow_notice do
       data {{
              remark: '修改申请',
            }}
     end
  end
end
