# -*- coding: utf-8 -*-
module CaresHelper
  
  def notice_types
    NoticeType.all.map do |type|
      [type.name,type.id]
    end
  end
end
