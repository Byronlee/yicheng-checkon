# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :trainee do
    dept_id "00000000"
    username "you"
    salary_time {2.days.ago.to_date}
  end
end
