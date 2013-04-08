# encoding: utf-8
class TraineeRecord 
  include Mongoid::Record

  field :is_deleted,type: Boolean,default: false

  default_scope where(is_deleted: false)

  belongs_to :trainee

  def self.merge o_id,n_id
     user = Trainee.find(o_id)
     user.trainee_records.map do |r|
       p StaffRecord.create!(r.handle_attrs(n_id))
       r.update_attributes(is_deleted: true)
     end
     user.to_staff
  end

  def self.trainees
    self.or({state: "checking"},{state: "registered",attend_date: Date.today}).asc(:state)
  end

  def handle_attrs n_id
    cloned_attrs = attributes.clone
    cloned_attrs.update("staffid" => n_id).delete_if{|k,v|k=="_id" || k=="is_deleted"}
    cloned_attrs
  end
end
