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
 
<<<<<<< HEAD
=======
  resources :work_flows do
    collection do
      post :lanuch
    end
  end
>>>>>>> 45051b3054d2831f11e98203d09eb85e4fc8d12c


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
  match  'approval' => 'tasks#approval' ,:as => :approval
<<<<<<< HEAD
  match 'apply'     => 'flows#apply'   , :via => :post
  match 'approve'   => 'flows#approve' , :via => :post


=======
>>>>>>> 45051b3054d2831f11e98203d09eb85e4fc8d12c

  root :to => "homes#index"
end
