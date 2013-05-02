class Task
  # to use cancan
  # authorize_resource :class => false  is bad
  include Mongoid::Document
end
