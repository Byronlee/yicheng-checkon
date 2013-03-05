# -*- coding: utf-8 -*-
class CountsController < ApplicationController
  def index

    behaves = Behave.all.inject({}) do |h ,value|
      h.merge({value.name => 0})
    end
    @stats = Count.addup.map do |count|
      
      user = User.new(count["staffid"])
      count["result"].map do | behave_id , num |
        behaves["#{Behave.find(behave_id).name}"] = num         
      end

      {user_no: user.user_no , username: user.username , behaves: behaves }
      
    end
  end
end

