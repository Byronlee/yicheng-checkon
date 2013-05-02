require 'spec_helper'
describe "routing to exceptions" do
  it "routes /cancan_error to exceptions#cancan_error" do
    expect(:get => cancan_error_path).to route_to(
      :controller => "exceptions",
      :action => "cancan_error",
    )
  end

  it "routes /render_404 to exceptions#render_404" do
    expect(:get => render_404_path).to route_to(
      :controller => "exceptions",
      :action => "render_404",
    )
  end

  it "routes /browser to exceptions#browser_error" do
    expect(:get => browser_path).to route_to(
      :controller => "exceptions",
      :action => "browser_error",
    )
  end

  it "routes /:anything to exceptions#routing_error" do
    expect(:get => "/not_exist_routing").to route_to(
      :controller => "exceptions",
      :action => "routing_error",
      :anything => "not_exist_routing",
    )
  end
end
