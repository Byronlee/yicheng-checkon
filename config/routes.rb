Attendance::Application.routes.draw do

  resources :tasks

  resources :counts do
    collection do
      get :amount
    end
  end

  resources :trainees do
    collection do
      post :merge
    end
  end

  post "staff_records/update" 

  resources :modifies
  resources :examines

  resources :staff_records do
    collection do 
      get  :fast_register
      get  :operate
      post :search
      post :query_attach
    end
  end

  resources :perssions

  resources :notices
  resources :counts
  post 'counts/update'

  match 'logout'     => 'application#logout'
  match 'registrar'  => 'tasks#registrar' ,:as => :registrar
  match 'approval'   => 'tasks#approval' ,:as => :approval
  match 'ajax_attend_tree' => 'homes#ajax_attend_tree' ,:via => :post
  match 'ajax_dept_users' => 'homes#ajax_dept_users'
  match 'autocomplete/search_users' => 'homes#search_users'
  match 'export' => 'counts#export'
  root :to => "homes#index"


  match 'cancan_error'    => 'exceptions#cancan_error'
  match 'render_404'      => 'exceptions#render_404'
  match 'browser'    => 'exceptions#browser_error'

  match '/:anything', to: "exceptions#routing_error", as: :error, :constraints => {:anything => /.*/}
  

end
