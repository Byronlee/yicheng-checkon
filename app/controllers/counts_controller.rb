# -*- coding: undecided -*-
class CountsController < ApplicationController
  def index
  end




















end

BDD
1. create date records and checkins
 do(each)
  Record.create(create_at: Date.today, total: config.expection)
 
2. a clerk check the records and checkins
  2.1 when config.expection arrived
  @record =  Record.find  一个一天

  

  @record.checkins.do {|c| 上午 == 到 累计计数 下午  }if record.create_at + config.expecition == Date.today
