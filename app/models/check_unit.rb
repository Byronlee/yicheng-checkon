class CheckUnit
  include Mongoid::Document

  field :name, type: String
  field :ratio, type: Integer

  BASE = 100 
end
