class BehaveType
  include Mongoid::Document

  field :name, type: String
  has_many :behaves, class_name: 'Behave'

# validates_presence_of :name
# validates_uniqueness_of :name
end
