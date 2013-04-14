# -*- coding: utf-8 -*-
class TasksController < ApplicationController

  def registrar
    @staffs = Task.staffs current_user
    @trainees = Task.trainees
    @registrar_notices = Notice.registrar current_user
  end

  def approval
    @approval_notices = Notice.approval
  end

end
