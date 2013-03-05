# -*- coding: utf-8 -*-
class CountsController < ApplicationController
  before_filter :init_behaves , only: [:index]
	
  def index
    counts = Count.addup
    if counts.any?
      @stats = counts.map do |count|
        user = User.new(count["staffid"])
        behaves = Hash.new.replace(@init)
        count["result"].map do | behave_id , num |
          behaves["#{Behave.find(behave_id).name}"] = num         
        end
        {user_no: user.user_no , username: user.username , behaves: behaves }
      end
    end
  end

  private 
    def init_behaves
      @init = Behave.all.inject({}) do |bh ,value|
        bh.merge({value.name => ""})
      end
    end
end

