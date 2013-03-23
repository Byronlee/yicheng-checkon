# -*- coding: utf-8 -*-
module CountsHelper



  def dept_ancestors staffid
   user =  User.resource(staffid)
   user.dept_ancestors.delete_if{|dept| dept[0]=="4028809b3c60dcc8013c60e107810001" || dept[0]=="4028809b3c6fbaa7013c6fbc39510002" }
       .inject(""){|str,position| str+position[1]+"/"}+user.dept_name
   end



  def count_table_titles type
     type.all.inject(["所在位置","工号","姓名"]) do |arr , bh |
      arr << bh.name
    end
  end


  def format v
    v.eql?(0) ? "" : v
  end

end
