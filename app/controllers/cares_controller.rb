# -*- coding: utf-8 -*-
class CaresController < ApplicationController

  def index
    @cares = Notice.all
  end

end
