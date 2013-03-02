Attendance::Application.routes.draw do
  get "records/index"
  get "records/whether_checkin"
  post "records/fast_register"
  resources :records
  root :to => "records#index"


end
