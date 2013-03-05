Attendance::Application.routes.draw do

  resources :counts , only: [:index]
  resources :records do
    collection do 
      get "fast_register"
      get "whether_checkin"
    end
  end
  root :to => "records#index"
end
