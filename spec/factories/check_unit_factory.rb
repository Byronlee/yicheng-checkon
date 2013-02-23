# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :check_unit, class: :check_unit do

    ratio 50

    factory :forenoon do
      name '上午'
    end

    factory :afternoon do
      name '下午'
    end
  end
end
