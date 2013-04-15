# -*- coding: utf-8 -*-
module ApplicationHelper
 
 def FormatDate time
    case (Time.now.to_date - time.to_date)
    when 0
      t('time.today')
    when 1
      t('time.yesterday')
    when 2
      t('time.before_yesterday')
    else
      time
    end
  end
end
