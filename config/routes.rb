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

  resources :staff_records do
    collection do 
      get  :fast_register
      get  :operate
      post :operate
      post :query_attach
    end
  end

  resources :notices
  
  match 'logout'     => 'application#logout'
  match 'registrar'  => 'tasks#registrar' ,:as => :registrar
  match 'approval'   => 'tasks#approval' ,:as => :approval
  match 'apply'      => 'flows#apply'   , :via => :post
  match 'approve'    => 'flows#approve' , :via => :post
  match 'message/view'     => 'flows#view' , :via => :post
  match 'ajax_attend_tree' => 'homes#ajax_attend_tree' ,:via => :post
  root :to => "homes#index"
end
