class Modify
  include Mongoid::Document

  field :checkins ,type:Hash
  field :remark, type:String  
  field :decision , type: String , default: 'agree'
   
# validate :equal_checkins
  belongs_to :staff_record
  has_many :notices

end
