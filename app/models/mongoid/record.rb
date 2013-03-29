# -*- coding: utf-8 -*-
module Mongoid
  module Record
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include Mongoid::Timestamps::Updated::Short
      include Mongoid::StateMachine

      field :staffid, type: String 
      field :staff_name , type: String 
      field :user_no, type: String 
      field :nick_name, type: String 
      field :record_person , type: String 
      field :record_person_name , type: String
      field :record_zone , type: String 
      field :record_zone_name , type: String 
      field :attend_date , type: String
      field :created_date, type: String,default: Date.today.to_s

      embeds_many :checkins
      has_many    :modify_records
    #validates_presence_of :staffid , :record_person , :record_zone
     # staffid,created_at共同检验唯一约束,防止重复产生记录
   # validates_uniqueness_of :staffid ,:scope => :created_at 

      after_create do |record|
        if checkins.count == 0
          CheckUnit.all.each do |unit|
            record.checkins.create!( check_unit_id: unit.id, behave_id: Behave.default.id )
          end
        end
      end

    end

    module InstanceMethods
      def c_at
        _id.generation_time
      end
    end

    module  ClassMethods 
      def state state
        where(state: state)
      end

      def register arg
        arg[:record].each do | user_id , checks| 
          record = get_record user_id,arg[:time]
          checks.map do |unit_id,behave_id|
            record.checkins.check_unit.find(unit_id)
            record.checkins.find_by(check_unit_id: unit_id).update_attribute(:behave_id , behave_id)
          end
          record.update_attribute(:attend_date,Date.today)
          record.register
        end
      end

      def new_record *arg
        create!(staffid: arg[0],
                staff_name: arg[1],
                user_no: arg[2],
                nick_name: arg[3],
                record_person_name: arg[4],
                record_person: arg[5],
                record_zone: arg[6],
                record_zone_name: arg[7]
               )
      end

      def get_record staffid,date
        where(staffid: staffid,created_date: date).first
      end

    end
  end
end
