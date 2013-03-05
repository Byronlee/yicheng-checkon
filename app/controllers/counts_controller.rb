# -*- coding: utf-8 -*-
class CountsController < ApplicationController
  before_filter :init_behaves , only: [:index]
	
  def index
    counts = Count.addup
    if counts.empty?
      @stats = counts.map do |count|
        user = User.new(count["staffid"])
        behaves = Hash.new.replace(@init)
        count["result"].map do | behave_id , num |
          behaves["#{Behave.find(behave_id).name}"] = num         
        end
        {user_no: user.user_no , username: user.username , behaves: behaves }
      end
      sort_by_user_no
    end
  end

  private 
    def init_behaves
      @init = Behave.all.inject({}) do |bh ,value|
        bh.merge({value.name => ""})
      end
    end

    def sort_by_user_no
      @stats.sort_by do |s|
        s[:user_no]
      end
    end
end

