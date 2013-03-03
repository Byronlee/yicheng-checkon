# -*- coding: utf-8 -*-
module RecordsHelper

 def current_user
   @current_user
 end



 def FormatDate time
   case (Time.now.to_date - time.to_date)
   when 0
     "今天"
   when 1
     "昨天"
   when 2
     "前天"
   else
     time
   end
 end
end
