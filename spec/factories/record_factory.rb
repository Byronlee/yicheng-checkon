# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :record, class: :record do
    factory :yesterday do
      date { 1.days.ago }
      association :user, factory: :employee
    end
  end
end
