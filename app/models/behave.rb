class Behave
  include Mongoid::Document

  field :name, type: String
  field :default, type: Boolean, default: false
  field :proper, type: Boolean
  belongs_to :behave_type

#  has_many :checkins
# validates_presence_of :name, :proper
# validates_uniqueness_of :name

  def self.default
    where(default: true).first
  end
end
