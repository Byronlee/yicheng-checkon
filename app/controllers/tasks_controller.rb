# -*- coding: utf-8 -*-
class TasksController < ApplicationController
  def registrar
    @staffs = Task.staffs
    @trainees = Task.trainees
    @messages = Message.registrar.decorate
  end

  def approval
    @messages = Message.approval.decorate
  end
end
