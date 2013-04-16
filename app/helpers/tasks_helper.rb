# -*- coding: utf-8 -*-
module TasksHelper

  def count_task tasks
    tasks.select{|s|s[:state]=='checking'}.count()
  end

  def render_no_content
    render "common/no_content" , :message =>  t('.no_content.no_task_tip')
  end
end
