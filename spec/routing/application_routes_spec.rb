require 'spec_helper'
describe "routing to application" do
  it "routes /logout to application#logout" do
    expect(:get => logout_path).to route_to(
      :controller => "application",
      :action => "logout",
    )
  end
end
