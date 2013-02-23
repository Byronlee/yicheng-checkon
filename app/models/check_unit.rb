class CheckUnit
  include Mongoid::Document

  field :name, type: String
  field :ratio, type: Integer

  def self.BASE
    100
  end
end
