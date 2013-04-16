# -*- coding: utf-8 -*-
module TasksHelper

  def count_task tasks
    tasks.select{|s|s[:state]=='checking'}.count()
  end
end
