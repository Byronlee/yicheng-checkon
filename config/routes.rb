Attendance::Application.routes.draw do

  resources :counts , only: [:index]

  post "records/update" 
 
  resources :records do
    collection do 
      get "fast_register"
      get "whether_checkin" 

    end
  end
  root :to => "records#index"
end
