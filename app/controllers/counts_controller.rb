# -*- coding: utf-8 -*-
class CountsController < ApplicationController
  before_filter :behave_init , only: [:index]

  def index
    @stats = Count.addup.map do |count|
      user = User.new(count["staffid"])
      h = Hash.new.replace(@init)
      count["result"].map do | behave_id , num |
        h["#{Behave.find(behave_id).name}"] = num         
      end
      {user_no: user.user_no , username: user.username , behaves: h }
    end
  end

  def behave_init
    @init = Behave.all.inject({}) do |h ,value|
      h.merge({value.name => 0})
    end
  end
end

