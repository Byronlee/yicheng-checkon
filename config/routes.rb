Attendance::Application.routes.draw do

  resources :counts do
    collection do
      get :amount
    end
  end

  resources :users do
    collection do
      get :ajax_user_select
      post :merge
    end
  end
 
  post "records/update" 

  resources :records do
    collection do 
      get  :fast_register
      get  :whether_checkin 
      get  :operate
      post :query
      post :query_attach
      post :ajax_select
      get  :permission
      get  :tree_dept
    end
  end
  root :to => "records#index"
end
