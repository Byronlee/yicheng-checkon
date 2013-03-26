# encoding: utf-8
class TraineeRecord 
  include Mongoid::Record

  field :is_deleted,type: Boolean,default: false

  default_scope where(is_deleted: false)

  belongs_to :user

# @current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")

  def self.trainee_everyday_records
    users = User.scoped
    users.map do | u |
      new_record u.id,u.username,Date.today,u.user_no,"","",User.current_user.username,"","meili"
    end
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

  def handle_attrs n_id
    cloned_attrs = attributes.clone
    cloned_attrs.update("staffid" => n_id).delete_if{|k,v|k="_id" || k="is_deleted"}
    cloned_attrs
  end

end
