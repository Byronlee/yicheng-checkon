require 'spec_helper'
describe "routing to tasks" do
  it "routes /counts to counts#index" do
    expect(:get => counts_path).to route_to(
      :controller => "counts",
      :action => "index",
    )
  end

  it "routes /counts/create to counts#create" do
    expect(:post => "/counts").to route_to(
      :controller => "counts",
      :action => "create",
    )
  end

  it "routes /counts/export to counts#export" do
    expect(:get => export_counts_path).to route_to(
      :controller => "counts",
      :action => "export",
    )
  end
end
