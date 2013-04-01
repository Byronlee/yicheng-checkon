# -*- coding: utf-8 -*-
module TasksHelper




  def count_task tasks
    tasks.inject(0) do |count ,item| 
      count += 1 if item[:state].eql?("checking")
      count
    end
  end

end
