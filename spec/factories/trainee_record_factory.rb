# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :trainee_record do
    factory :yesterday_with_employee ,:class => StaffRecord do
      staffid "4028809b3c6fbaa7013c6fbc3db41bc3"
      record_person "4028809b3c6fbaa7013c6fbc3db41bc3"
      attend_date Date.today -1
      record_zone  "4028809b3c6fbaa7013c6fbc39900388"

      before(:create) do |record|
      # [:work ,:sick_leave, :forenoon, :afternoon ].map { |unit|create unit }
      end
    end

    factory :trainee_records do 
      association :user
    end
  end
end
