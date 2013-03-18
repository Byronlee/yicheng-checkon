# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :user do
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

    factory :no_number_employee do 
      dept_id "00000000"
      username "you"
      salary_time {2.days.ago.to_date}
    end

  end
end
