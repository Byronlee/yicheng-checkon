# -*- coding: utf-8 -*-
class StaffRecordDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages ,:total_pages
  delegate :nick_name ,:record_person_name,:record_zone_name,:staff_name,:user_no,:checkins,:attend_date ,:staffid ,:created_date,:id

end
