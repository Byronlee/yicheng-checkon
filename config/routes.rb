Attendance::Application.routes.draw do

  resources :counts , only: [:index]

  post "records/update" 
 
  resources :records do
    collection do 
      get "fast_register"
      get "whether_checkin" 
      get "operate"
      post "query"
    end
  end
  root :to => "records#index"
end
