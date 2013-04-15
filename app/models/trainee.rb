# encoding: utf-8
class Trainee
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  default_scope where(state: "trainee")

  scope :belong, ->(user){ scoped.in(dept_id: user.dept_ids) }

  field :salary_time ,type: String
  field :user_no ,type: String, default: "000000"
  field :username ,type: String
  field :state ,type: String, default: "trainee"
  field :dept_id ,type:String 
  
  validates_presence_of :username ,:dept_id
  validates_uniqueness_of :username

  #validates_presence_of :salary_time
  validate :before_today

  has_many :trainee_records

  def  create_defalut_records cu 
    (0...(initialized_days)).each do |t|
      record = TraineeRecord.new_record(id,
                                        username,
                                        user_no,
                                        "",
                                        cu.username,
                                        cu.staffid,
                                        cu.dept_id,
                                        cu.dept_name)
      record.update_attributes(created_date: Date.today-t,trainee_id: id)
    end
    save
  end

  def save_with_validate current_user
    valid? ? create_defalut_records(current_user) : false
  end
  
  def initialized_days
    (Date.today - Date.parse(salary_time)).to_i + 1
  end

  def to_staff
    update_attributes(state: "staff")
  end

  def finish?
    trainee_records.map(&:state).include? 'checking'
  end
  
  def before_today
    if salary_time.empty?
      errors.add(:salary_time,'计薪时间不能为空')
    elsif Date.parse(salary_time) > Date.today
      errors.add(:salary_time, '计薪时间不能超过今天')
    end
  end
end
