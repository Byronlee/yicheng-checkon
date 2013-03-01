Attendance::Application.routes.draw do
  get "records/index"
  resources :records
  root :to => "records#index"
end
