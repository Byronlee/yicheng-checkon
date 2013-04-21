# -*- coding: utf-8 -*-
class ExaminesController < ApplicationController

  # TODO 当所选时间段内  考勤记录为空不能发起审核
  def create
    examine = Examine.new(params[:examine][:data])
    return  render :json => false  unless examine.save_with_no_old_examine
    checkers = Webservice.get_registrars
    checkers.each do |checker_id |
      examine.proces.create(registrar: checker_id)
      params[:examine][:notice][:receiver] = checker_id
      examine.notices.create(params[:examine][:notice]).examine_notice_content
    end
    render "counts/_count_page" ,:locals => {:counts => Count.counts }, :layout => false
  end

  def destroy
    examine = Examine.find(params[:examine_id])
    examine.notices.update_all(state: true)
    examine.update_attributes(state: false)
    render "counts/_count_page" ,:locals => {:counts => Count.counts }, :layout => false
  end
end
