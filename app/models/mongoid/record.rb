# -*- coding: utf-8 -*-
module Mongoid
  module Record
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Timestamps::Updated::Short
      include Mongoid::StateMachine

      field :staffid, type: String 
      field :record_person , type: String 
      field :attend_date , type: String
      field :created_date, type: String,default: Date.today.to_s

      embeds_many :checkins

      after_create do |record|
        if checkins.count == 0
          CheckUnit.all.each do |unit|
            record.checkins.create!( check_unit_id: unit.id, behave_id: Behave.default.id )
          end
        end
      end
    end

      def c_at
        _id.generation_time
      end
      def update_checkins(checks)
        checks.map  do |check_unit_id , behave_id|
          checkins.find_by(check_unit_id: check_unit_id).update_attribute(:behave_id ,behave_id)
        end
      end

      def user
        User.resource(staffid)
      end
      
      def record_person_name
        User.resource(record_person)
      end

    module  ClassMethods 
      def state state
        where(state: state)
      end

      def register arg ,current_user
        arg[:record].each do | user_id , checks| 
          record = get_record user_id,arg[:time]
          record.update_checkins(checks)
          record.update_attribute(:attend_date,Date.today)
          record.update_attribute(:record_person,current_user.staffid)
          record.register
        end
      end
 
      def get_record id,date
        where(staffid: id,created_date: date).first
      end
    end
  end
end
