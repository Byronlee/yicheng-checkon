Attendance::Application.routes.draw do


  resources :records do 
    collection do
      get "records/whether_checkin"
      post "records/fast_register"
    end
  end
  
  root :to => "records#index"


end
