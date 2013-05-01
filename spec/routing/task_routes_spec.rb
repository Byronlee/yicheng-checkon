require 'spec_helper'
describe "routing to tasks" do
  it "routes /registrar to tasks#registrar" do
    expect(:get => "/registrar").to route_to(
      :controller => "tasks",
      :action => "registrar",
    )
  end

  it "routes /approval to tasks#approval" do
    expect(:get => "/approval").to route_to(
      :controller => "tasks",
      :action => "approval",
    )
  end

end
