# -*- coding: utf-8 -*-
class TasksController < ApplicationController

  # TODO 要声明 没有model cancan

  def registrar 
    @staffs = StaffRecord.staffs current_user    
    @trainees = current_user.trainee_tasks
    @registrar_notices = Notice.registrar current_user
  end

  def approval
    @approval_notices = Notice.approval
  end
end
