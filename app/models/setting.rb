class Setting < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
  load! if Rails.env.development?
end
