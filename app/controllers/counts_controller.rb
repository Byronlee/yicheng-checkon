# -*- coding: utf-8 -*-
class CountsController < ApplicationController

  def index
    counts = Count.addup
    if counts.any?
      @stats = counts.map do |count|
        user = User.new(count["staffid"])
        behaves = init_behaves
        count["result"].map do | behave_id , num |
          behaves["#{Behave.find(behave_id).name}"] = num         
        end
        {user_no: user.user_no , username: user.username , behaves: behaves }
      end
    end
  end

  private 
    def init_behaves
      Behave.all.inject({}) do |bh ,value|
        bh.merge({value.name => 0})
      end
    end
end

