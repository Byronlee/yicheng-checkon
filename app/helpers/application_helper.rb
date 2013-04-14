# -*- coding: utf-8 -*-
module ApplicationHelper
 
 def FormatDate time
    case (Time.now.to_date - time.to_date)
    when 0
      t("helper.records.today")
    when 1
      t("helper.records.yesterday")
    when 2
      t("helper.records.before_yesterday")
    else
      time
    end
  end
end
