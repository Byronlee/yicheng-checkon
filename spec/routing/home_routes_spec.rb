require 'spec_helper'
describe "routing to tasks" do
  it "routes root to homes#index" do
    expect(:get => root_path).to route_to(
      :controller => "homes",
      :action => "index",
    )
  end

  it "routes /ajax_attend_tree to homes#ajax_attend_tree" do
    expect(:post => ajax_attend_tree_path).to route_to(
      :controller => "homes",
      :action => "ajax_attend_tree",
    )
  end

  it "routes /ajax_dept_users to homes#ajax_dept_users" do
    expect(:post => ajax_dept_users_path).to route_to(
      :controller => "homes",
      :action => "ajax_dept_users",
    )
  end

  it "routes /autocomplete/search_users to homes#search_users" do
    expect(:get => "/autocomplete/search_users").to route_to(
      :controller => "homes",
      :action => "search_users",
    )
  end
end
