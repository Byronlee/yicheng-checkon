require 'spec_helper'
describe "routing to examines" do
  it "routes /examines to examines#index" do
    expect(:get => examines_path).to route_to(
      :controller => "examines",
      :action => "index",
    )
  end

  it "routes /examines to examines#create" do
    expect(:post => '/examines').to route_to(
      :controller => "examines",
      :action => "create",
    )
  end

  it "routes /examines/show/:id to examines#show" do
    expect(:get => examine_path("123456")).to route_to(
      :controller => "examines",
      :action => "show",
      :id => "123456",
    )
  end

  it "routes /examines/:id to examines#update" do
    expect(:put => examine_path("123456")).to route_to(
      :controller => "examines",
      :action => "update",
      :id => "123456",
    )
  end

  it "routes /examines/:id to examines#destroy" do
    expect(:delete => examine_path("123456")).to route_to(
      :controller => "examines",
      :action => "destroy",
      :id => "123456",
    )
  end

  it "routes proces_detail to examines#proces_detail" do
    expect(:post => proces_detail_path).to route_to(
      :controller => "examines",
      :action => "proces_detail",
    )
  end
end
