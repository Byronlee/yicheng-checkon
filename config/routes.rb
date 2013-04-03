Attendance::Application.routes.draw do

  resources :tasks
  
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
   
  match 'registrar' => 'tasks#registrar' ,:as => :registrar
  match 'approval' => 'tasks#approval' ,:as => :approval
  match 'apply'     => 'flows#apply'   , :via => :post
  match 'approve'   => 'flows#approve' , :via => :post
  match 'message/view'   => 'flows#view' , :via => :post
  root :to => "homes#index"
end
