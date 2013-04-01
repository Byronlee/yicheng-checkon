class WorkFlowsController < ApplicationController
  def lanuch
    WorkFlow.define(params).launch
    redirect_to "/staff_records/operate"
  end

  def refuse
  end

  def approve
  end
end
