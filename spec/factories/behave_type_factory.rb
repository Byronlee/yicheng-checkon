# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :behave_type, class: :behave_type do
    factory :present do
      name '上班'
    end

    factory :leave do
      name '请假'
    end

    factory :away do
      name '旷工'
    end
  end
end
