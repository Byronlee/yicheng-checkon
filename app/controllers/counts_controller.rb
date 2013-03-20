# -*- coding: utf-8 -*-
class CountsController < ApplicationController
  before_filter :init_behaves , only: [:index]
	
  def index
    counts = Count.addup("2013-03-01","2013-05-01","registered")
    unless counts.empty?
     @stats = sort_by_field Count.counts_result(counts,@init),:user_no
    end
  end

  private 
    def init_behaves
      @init = Behave.all.inject({}) do |bh ,value|
        bh.merge({value.name => ""})
      end
    end
end

