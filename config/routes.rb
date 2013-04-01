Attendance::Application.routes.draw do

  resources :tasks

  mount Feedback::Engine => '/feedback', as: 'feedback_app'
  
  match  'logout' => 'application#logout'

  resources :counts do
    collection do
      get :amount
    end
  end

  resources :trainees do
    collection do
      get :ajax_user_select
      post :merge
      get :logout
    end
  end
 
  resources :work_flows do
    collection do
      post :lanuch
    end
  end


  post "staff_records/update" 

  resources :staff_records do
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
 root :to => 'tasks#index'
end
