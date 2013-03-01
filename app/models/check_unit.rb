class CheckUnit
  include Mongoid::Document

  field :name, type: String
  field :ratio, type: Integer

  has_many :checkins
  BASE = 100 
end
