class Trainee
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  default_scope where(state: "trainee")

  field :salary_time ,type: String
  field :user_no ,type: String, default: "000000"
  field :username ,type: String
  field :state ,type: String, default: "trainee"
  field :dept_id

  validates_presence_of :username , :salary_time , :dept_id
  validates_uniqueness_of :username

  has_many :trainee_records

  after_create do |trainee|
     user = User.current_user
    (0...(trainee.initialized_days)).each do |t|
      record = TraineeRecord.new_record(trainee.id,
                                        trainee.username,
                                        trainee.user_no,
                                        "",
                                        user.username,
                                        user.staffid,
                                        user.dept_id,
                                        user.dept_name)
      record.update_attributes(created_date: Date.today-t,trainee_id: trainee.id)
    end
  end
  
  def initialized_days
    (Date.today - Date.parse(salary_time)).to_i + 1
  end

  def to_staff
    update_attributes(state: "staff")
  end
end
