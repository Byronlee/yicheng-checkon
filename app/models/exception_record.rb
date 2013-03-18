# encoding: utf-8
class ExceptionRecord < Record
  belongs_to :user

  def self.exception_everyday users
      current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")
      users.map do | u |
        u.exception_records.create()
        (0...(u.initialized_days)).map do |t|
          u.exception_records.find_or_create_by(attend_date: Date.today-t,record_person: current_user.username,record_zone: "meili")
        end
      end
  end

  def self.merge o_id,n_id
     user = User.find(o_id)
     user.exception_records.each do |record|
       record.update_attributes(_type: "Record",staffid: n_id)
     end
     user.destroy
  end
end
