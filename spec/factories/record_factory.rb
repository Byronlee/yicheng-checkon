# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :record do
    factory :yesterday_with_employee do
      staffid "4028809b3c6fbaa7013c6fbc3db41bc3"
      record_person "4028809b3c6fbaa7013c6fbc3db41bc3"
      attend_date "2013-04-05"
      record_zone  "4028809b3c6fbaa7013c6fbc39900388"
    end
    
    factory :exception_records do 
      association :user
    end
  end
end
