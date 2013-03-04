class Checkin
  include Mongoid::Document

 # belongs_to :record
  embedded_in :record
  belongs_to :check_unit
  belongs_to :behave

# validates_presence_of :record, :check_unit, :behave
# validates_uniqueness_of :check_unit, scope: [:record]
  
  
end
