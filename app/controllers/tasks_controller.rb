# -*- coding: utf-8 -*-
class TasksController < ApplicationController
  def index
     case current_user.role
           when 'Registrar'
             # action
           when 'Approval'
             # action
           else
             # other
           end
  end
end
