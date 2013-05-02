require 'spec_helper'
describe "routing to modifies" do
  it "routes /modifies to modifies#index" do
    expect(:post => modifies_path).to route_to(
      :controller => "modifies",
      :action => "create",
    )
  end

  it "routes /modifies/update/:id to modifies#update" do
    expect(:put => modify_path("123456")).to route_to(
      :controller => "modifies",
      :action => "update",
      :id   => "123456"
    )
  end

  it "routes /modifies/destory/:id to modifies#destory" do
    expect(:delete => modify_path("123456")).to route_to(
      :controller => "modifies",
      :action => "destroy",
      :id   => "123456"
    )
  end
end
