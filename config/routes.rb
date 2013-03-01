Attendance::Application.routes.draw do
  get "records/index"
  get "records/whether_checkin"
  resources :records
  root :to => "records#index"


end
