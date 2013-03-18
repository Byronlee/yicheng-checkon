Attendance::Application.routes.draw do

  resources :counts , only: [:index]
  resources :users 
 
  post "records/update" 

  resources :records do
    collection do 
      get "fast_register"
      get "whether_checkin" 
      get "operate"
      post "query"
      post "ajax_select"
    end
  end
  root :to => "records#index"
end
