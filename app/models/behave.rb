class Behave
  include Mongoid::Document

  field :default, type: Boolean

  def self.default
    where(default: true).first
  end
end
