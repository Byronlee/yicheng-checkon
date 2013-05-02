Attendance::Application.routes.draw do

  resources :counts , :only => [:index, :create] do
    get :export ,:on => :collection
  end

  resources :trainees, :only => [:index, :create] do
    post :merge ,:on => :collection
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

  match 'logout'     => 'application#logout'
  match 'registrar'  => 'tasks#registrar' ,:as => :registrar
  match 'approval'   => 'tasks#approval' ,:as => :approval
  match 'ajax_attend_tree' => 'homes#ajax_attend_tree' ,:via => :post
  match 'ajax_dept_users' => 'homes#ajax_dept_users'
  match 'autocomplete/search_users' => 'homes#search_users'
  match 'proces_detail' =>  'examines#proces_datail' ,:as => :proces_detail ,:via => :post

  match 'cancan_error'    => 'exceptions#cancan_error'
  match 'render_404'      => 'exceptions#render_404'
  match 'browser'    => 'exceptions#browser_error'
  root :to => "homes#index"

  match '/:anything', to: "exceptions#routing_error", as: :error, :constraints => {:anything => /.*/}
end
