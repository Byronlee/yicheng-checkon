# -*- coding: utf-8 -*-
class TasksController < ApplicationController

  def registrar
    @staffs = Task.staffs
    @trainees = Task.trainees
    @registrar_messages = Message.registrar.decorate
  end

  def approval
    @approval_messages = Message.approval.decorate
  end

end
