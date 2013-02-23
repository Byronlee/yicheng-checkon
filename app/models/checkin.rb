class Checkin
  include Mongoid::Document

  belongs_to :record
  belongs_to :check_unit
end
