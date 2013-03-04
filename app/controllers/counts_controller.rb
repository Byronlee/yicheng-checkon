class CountsController < ApplicationController
  def index
    Count.stat
  end

end
