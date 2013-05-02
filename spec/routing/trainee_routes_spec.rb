require 'spec_helper'
describe "routing to trainees" do
  it "routes /trainees to trainees#index" do
    expect(:get => trainees_path).to route_to(
      :controller => "trainees",
      :action => "index",
    )
  end

  it "routes /trainees to trainees#create" do
    expect(:post => "/trainees").to route_to(
      :controller => "trainees",
      :action => "create",
    )
  end

  it "routes /trainees/merge to trainees#merge" do
    expect(:post => merge_trainees_path).to route_to(
      :controller => "trainees",
      :action => "merge",
    )
  end
end
