Attendance::Application.routes.draw do

  resources :counts , :only => [:index, :create] do
    get :export ,:on => :collection,:as => 'export' 
  end

  resources :trainees, :only => [:index, :create] do
    post :merge ,:on => :collection
  end

  # TODO move update to resources
  post "staff_records/update" 
  resources :staff_records,:only => ['index','show','edit'] do
    post :search ,:on => :collection
  end

  resources :modifies, :only => ['create','update','destroy']

  match 'proces_detail' =>  'examines#proces_detail' ,:via => :post
  resources :examines, :except => ['new','edit']

  # not be test 
  resources :perssions , :only => ['create','index','destroy']

  resources :cares , :only => ['index'] do
    post :query ,:on => :collection
  end

  match 'logout'     => 'application#logout'

  match 'registrar'  => 'tasks#registrar' ,:as => :registrar
  match 'approval'   => 'tasks#approval' ,:as => :approval

  match 'ajax_attend_tree' => 'homes#ajax_attend_tree' ,:via => :post
  match 'ajax_dept_users' => 'homes#ajax_dept_users'
  match 'autocomplete/search_users' => 'homes#search_users'
  root :to => "homes#index"

  match 'cancan_error'    => 'application_with_exceptions#cancan_error'
  match 'browser'    => 'application_with_exceptions#browser_error'

  match '/:anything', to: "application_with_exceptions#routing_error", as: :error, :constraints => {:anything => /.*/}
end
