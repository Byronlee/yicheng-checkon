# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :record, class: :record do
    factory :yesterday_with_employee do
      period { 1.days.ago }
      association :user, factory: :employee
    end
  end
end
