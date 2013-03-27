# encoding: utf-8
class TraineeRecord 
  include Mongoid::Record

  field :is_deleted,type: Boolean,default: false

  default_scope where(is_deleted: false)

  belongs_to :user

# @current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")


  def self.new_record *arg
    arg[0].trainee_records.create(  created_date: arg[1],
                                               record_person: arg[2],
                                               record_zone: arg[3],
                                               staffid: arg[0].id)
  end

  def self.merge o_id,n_id
     user = User.find(o_id)
     user.trainee_records.map do |r|
       StaffRecord.create!(r.handle_attrs(n_id))
       r.update_attributes(is_deleted: true)
     end
     user.to_staff
  end

  def self.trainee_records
    self.or({state: "checking"},{state: "registered",attend_date: Date.today})
  end

  def self.get_record id,time
    User.find(id).trainee_records.find_by(created_date: time)
  end

  def handle_attrs n_id
    cloned_attrs = attributes.clone
    cloned_attrs.update("staffid" => n_id).delete_if{|k,v|k="_id" || k="is_deleted"}
    cloned_attrs
  end

end
