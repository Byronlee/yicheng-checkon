# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :user  do
    factory :clerk do
     username 'admin'
     password 'admin'
      # login 'wenyuan'
      # sn '李'
      # cn '文员'
     end

    factory :employee do
      # login 'yuangong'
      # sn '张'
      # cn '职员'
     end
  end
end
