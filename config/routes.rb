Attendance::Application.routes.draw do
  mount Unirole::Engine => '/unirole', as: 'unirole_app'
  get "records/index"
  resources :records
  root :to => "records#index"
end
