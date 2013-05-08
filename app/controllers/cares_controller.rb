# -*- coding: utf-8 -*-
class CaresController < ApplicationController

  def index
    @cares = Notice.all
  end

  def query
    begin
      notices = NoticeType.find(params[:notice_type][:id]).notices
      notices = notices.between_date(Date.parse(params[:start_time]),Date.parse(params[:end_time]))
    rescue
      message =  "请选择需要查询的关注类型或者时间段"
      return render :json => message,:status => 500
    end
    render "cares/_cares_body",locals:{:cares => notices },:layout => false
  end
end
