# -*- coding: utf-8 -*-
class TasksController < ApplicationController

  def registrar
    @staffs = Task.staffs
    @trainees = Task.trainees
    @registrar_notices = Notice.registrar
  end

  def approval
    @approval_notices = Notice.approval
  end

end
