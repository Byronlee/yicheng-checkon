# -*- coding: utf-8 -*-
class HomesController < ApplicationController


  def index
    if current_user.registrar?
      redirect_to registrar_path
    end
    if current_user.approval?
      redirect_to approval_path
    end
  end
 end
