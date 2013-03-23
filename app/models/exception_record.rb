# encoding: utf-8
class ExceptionRecord < Record
  belongs_to :user
  default_scope where(_type: "ExceptionRecord")
  attr_accessible :_type,:record_zone,:record_person,:attend_date,:staffid

  @current_user =  User.resource("4028809b3c6fbaa7013c6fbc3db41bc3")

  def self.exception_everyday users=nil
    users ||= User.all
    users.map do | u |
      u.is_first ? previous(u) : today(u)
    end
  end

  def self.previous u
    (0...(u.initialized_days)).map do |t|
      new_e_record u,Date.today-t,@current_user.username,"meili"
    end
    u.not_first
  end

  def self.today u
    new_e_record u,Date.today,@current_user.username,"meili"
  end

  def self.new_e_record *arg
    arg[0].exception_records.find_or_create_by(  attend_date: arg[1],
                                               record_person: arg[2],
                                               record_zone: arg[3],
                                               staffid: arg[0].id)
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

  def self.exception_records
    ExceptionRecord.or({state: "checking"},{state: "registered",attend_date: Date.today})
  end

  def self.auto_submit
    Record.send(:auto_submit)
    super
  end
end
