# encoding: utf-8
class ExceptionRecord < Record
  belongs_to :user
  attr_accessible :_type

  def self.exception_everyday users
      current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
      users.map do | u |
        (0...(u.initialized_days)).map do |t|
          u.exception_records.create(attend_date: Date.today-t,record_person: current_user.username,record_zone: "meili")
        end
      end
  end

  def self.merge o_id,n_id
     user = User.find(o_id)
     user.exception_records.map do |r|
       r.update_attributes(_type: "Record")
       r.staffid =  n_id
       r.save
     end
     user.destroy
  end
end
