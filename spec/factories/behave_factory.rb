# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :behave, class: :behave do

    trait :default do
      default true
    end

    factory :work, traits: [:default] do
      name '全勤'
#     association :behave_type, factory: :present
    end

    factory :late do
      name '迟到'
#     association :behave_type, factory: :present
    end

    factory :sick_leave do
      name '病假'
#     association :behave_type, factory: :leave
    end

    factory :thing_leave do
      name '事假'
#     association :behave_type, factory: :leave
    end

    factory :neglect do
      name '旷工'
#     association :behave_type, factory: :away
    end

    factory :rest do
      name '轮休'
#     association :behave_type, factory: :away
    end
  end
end
