# -*- coding: utf-8 -*-
class CountsController < ApplicationController
#  before_filter :init_behaves , only: [:index]

  def index
    @stats = Count.addup.map do |count|
      user = User.new(count["staffid"])
      behaves = init_behaves
      count["result"].map do | behave_id , num |
        behaves["#{Behave.find(behave_id).name}"] = num         
      end
      {user_no: user.user_no , username: user.username , behaves: behaves }
    end
  end

  def init_behaves
    Behave.all.inject({}) do |bh ,value|
      bh.merge({value.name => 0})
    end
  end
end

