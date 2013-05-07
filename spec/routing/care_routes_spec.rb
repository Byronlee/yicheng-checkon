require 'spec_helper'
describe "routing to cares" do

  it "routes /cares to care#index" do
    expect(:get => cares_path).to route_to(
      :controller => "cares",
      :action => "index",
    )
  end
end
