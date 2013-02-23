class Checkin
  include Mongoid::Document

  belongs_to :record
  belongs_to :check_unit

  validates_uniqueness_of :check_unit, scope: [:record]
end
