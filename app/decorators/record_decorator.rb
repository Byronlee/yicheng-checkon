# -*- coding: utf-8 -*-
class RecordDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages ,:total_pages
  delegate :nick_name ,:record_person_name,:record_zone_name,:staff_name,:user_no,:checkins,:attend_date

  def dept_ancestors
   user =  User.resource(source.staffid)
   user.dept_ancestors.delete_if{|dept| dept[0]=="4028809b3c60dcc8013c60e107810001" || dept[0]=="4028809b3c6fbaa7013c6fbc39510002" }
       .inject(""){|str,position| str+position[1]+"/"}+user.dept_name
  end

  def  position   
    position =  User.resource(source.staffid).position
    position.any? ?  position.inject(""){|str,post| str+post[1]+"" } : "——"
  end

  

end
