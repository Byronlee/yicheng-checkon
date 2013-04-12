# -*- coding: utf-8 -*-
class NoticesController < ApplicationController

  def create
    record = 
    @notice = Notice.new(params)
    if @notice.launch?
    end
  end
end
