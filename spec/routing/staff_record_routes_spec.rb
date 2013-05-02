require 'spec_helper'
describe "routing to staff_records" do
  it "routes /staff_records to staff_records#index" do
    expect(:get => staff_records_path).to route_to(
      :controller => "staff_records",
      :action => "index",
    )
  end

  it "routes /staff_records/show/:id to staff_records#show" do
    expect(:get => staff_record_path("123456")).to route_to(
      :controller => "staff_records",
      :action => "show",
      :id => "123456",
    )
  end

  it "routes /staff_records/update to staff_records#update" do
    expect(:post =>"staff_records/update").to route_to(
      :controller => "staff_records",
      :action => "update",
    )
  end

  it "routes /staff_records/search to staff_records#search" do
    expect(:post =>"staff_records/search").to route_to(
      :controller => "staff_records",
      :action => "search",
    )
  end

end
