Attendance::Application.routes.draw do

  resources :tasks

  resources :counts do
    collection do
      get :amount
    end
  end

  resources :trainees do
    collection do
      get  :ajax_dept_users_select
      post :merge
    end
  end

  post "staff_records/update" 

  resources :modifies

  resources :staff_records do
    collection do 
      get  :fast_register
      get  :operate
      post :search
      post :query_attach
    end
  end

  resources :notices
  resources :counts

  match 'logout'     => 'application#logout'
  match 'registrar'  => 'tasks#registrar' ,:as => :registrar
  match 'approval'   => 'tasks#approval' ,:as => :approval
  match 'ajax_attend_tree' => 'homes#ajax_attend_tree' ,:via => :post
  match 'browser'    => 'homes#browser' ,  :via => :get
  root :to => "homes#index"
end
