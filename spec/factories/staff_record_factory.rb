# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :staff_record do
    sequence(:staffid) {|n| "#{n}" }
    sequence(:created_date) {|n| Date.today - n }

    factory :three_away do
      
    end
    before(:create) do |record|
      [:work ,:sick_leave,:away, :forenoon, :afternoon ].map { |unit|create unit }
    end

  end
end
