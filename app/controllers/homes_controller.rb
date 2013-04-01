# -*- coding: utf-8 -*-
class HomesController < ApplicationController


  def index
    case  current_user.role.first
    when 'Registrar'
      redirect_to registrar_path
    when 'Approval'
      redirect_to approval_path
    end
  end




 end
