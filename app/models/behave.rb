class Behave
  include Mongoid::Document

  field :name, type: String
  field :default, type: Boolean, default: false
  belongs_to :behave_type

  def self.default
    where(default: true).first
  end
end
