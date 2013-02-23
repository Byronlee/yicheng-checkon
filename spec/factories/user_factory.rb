# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :user, class: Unirole::User do
    factory :clerk do
      login 'wenyuan'
      sn '李'
      cn '文员'
    end

    factory :employee do
      login 'yuangong'
      sn '张'
      cn '职员'
    end
  end
end
