# -*- coding: utf-8 -*-

FactoryGirl.define do
  factory :user do
    staffid '123456'
    username 'simlegate'
    user_no '123456'
    dept_id '0000000'
    dept_name '美丽2'
    factory :registrar do
      roles ['Registrar']
    end
  end
end
