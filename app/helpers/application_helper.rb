module ApplicationHelper

 def is_empty? data
  data.empty?  ?  nil : (data.any? ? data : nil)
 end
end
