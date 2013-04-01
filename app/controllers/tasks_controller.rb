# -*- coding: utf-8 -*-
class TasksController < ApplicationController

  def registrar
    @staffs = Task.staffs
    @trainees = Task.trainees
  end


  def approval
  end



end
