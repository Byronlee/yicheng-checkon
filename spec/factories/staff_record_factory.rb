# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :staff_record do
    staffid "123"
    record_person "张三"

    factory :yesterday_record do
      created_date Date.today -1
      attend_date Date.today 
    end

      before(:create) do |record|
        [:work ,:sick_leave, :forenoon, :afternoon ].map { |unit|create unit }
      end

  end
end
