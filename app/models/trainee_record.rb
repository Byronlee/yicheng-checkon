# encoding: utf-8
class TraineeRecord 
  include Mongoid::Record

  field :is_deleted,type: Boolean,default: false

  default_scope where(is_deleted: false)

  belongs_to :trainee

  def self.merge o_id,n_id
     user = Trainee.find(o_id)
     attrs = user.trainee_records.map do |r|
       r.update_attributes(is_deleted: true)
       record = StaffRecord.by_staffid_and_date(n_id,r.created_date)
       record.delete unless record.blank?
       r.handle_attrs(n_id)
     end
     StaffRecord.create!(attrs)
     user.to_staff
  end

  def self.trainees
    self.or({state: "checking"},{state: "registered",attend_date: Date.today})
  end

  def handle_attrs n_id
    cloned_attrs = attributes.clone
    cloned_attrs.update("staffid" => n_id).delete_if{|k,v|k=="_id" || k=="is_deleted"}
    cloned_attrs
  end
 
  def user
    dept = Department.new(trainee.dept_id)
    {name: trainee.username,dept_name: dept.name,user_id: trainee.id}
  end
end
