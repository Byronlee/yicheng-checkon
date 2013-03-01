Attendance::Application.routes.draw do


  mount Unirole::Engine => '/unirole', as: 'unirole_app'

  get "records/index"

 # clerk route
  get "clerk/index"
  get "clerk/query"
  get "clerk/old_data"
  get "clerk/attend"
  get "clerk/task"
  api :version => 1 do
    resources :foods
  end


   # records route

  get "records/modify_atend_record"

  resource :records
  get "records/update"
  get "clerk/all_user"


  get "person/index"

  root :to => "records#index"

  get "person/stores"
  get "person/stores_index"
  get "person/clerk"
  get "person/mark_clerk"

  get "person/attendance_query"
  get "person/minister_view"
  get "person/minister_view_1"
  get "person/minister_day_view"

  post "login/login"
  get "login/logout"
end
