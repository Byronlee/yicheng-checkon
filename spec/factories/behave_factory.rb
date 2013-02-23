# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :behave, class: :behave do
    trait :good do
      proper true
    end

    trait :bad do
      proper false
    end

    factory :work, traits: [:good] do
      name '全勤'
      default true
      association :behave_type, factory: :present
    end

    factory :late, traits: [:bad] do
      name '迟到'
      association :behave_type, factory: :present
    end

    factory :sick_leave, traits: [:bad] do
      name '病假'
      association :behave_type, factory: :leave
    end

    factory :thing_leave, traits: [:bad] do
      name '事假'
      association :behave_type, factory: :leave
    end

    factory :neglect, traits: [:bad] do
      name '旷工'
      association :behave_type, factory: :away
    end

    factory :rest, traits: [:good] do
      name '轮休'
      association :behave_type, factory: :away
    end
  end
end
