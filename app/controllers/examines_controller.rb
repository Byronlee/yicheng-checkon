# -*- coding: utf-8 -*-
class ExaminesController < ApplicationController


  def create
    examine = Examine.new(params[:examine][:data])
    return  render :json => false  unless examine.save_with_no_old_examine
    checkers = Webservice.get_registrars
    checkers.each do |checker_id |
      examine.proces.create(registrar: checker_id)
      params[:examine][:notice][:receiver] = checker_id
      examine.notices.create(params[:examine][:notice]).examine_notice_content
    end
    render "counts/_count_page" ,:locals => {:counts => Count.counts(current_user) }, :layout => false
  end

  def update
    examine = Examine.find(params[:examine_id])
    examine.proces.where(registrar: current_user.staffid).first.update_attributes(state: true)
    examine.notices.where(receiver: current_user.staffid).first.update_attributes(state: true)
    render "counts/_count_page" ,:locals => {:counts => Count.counts(current_user)}, :layout => false
  end


  def destroy
    examine = Examine.find(params[:examine_id])
    examine.notices.update_all(state: true)
    examine.update_attributes(state: false)
    render "counts/_count_page" ,:locals => {:counts => Count.counts(current_user)}, :layout => false
  end
end
