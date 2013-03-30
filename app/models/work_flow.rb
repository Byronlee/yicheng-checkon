# encoding: utf-8
class WorkFlow
  include Mongoid::Document
  include Mongoid::Timestamps

  field :starter
  field :hander
  field :result

  belongs_to :staff_record
  has_many :messages

  # 定义流程
  def self.define p
    workitem = StaffRecord.find(p[:record_id]).work_flows.create(starter: User.current_user.staffid)
    workitem.messages.create(content: Message.message(p))
    workitem
  end

  # 启动流程
  def launch
    staff_record.apply
  end

  # 处理流程: 拒绝
  def refuse
    update_result("refuse")
    staff_record.refuse
    messages.create(content: "拒绝将xx的状态由xx变为xx")
  end
  
  # 处理流程: 同意
  def approve
    update_result("approve")
    staff_record.approve
    messages.create(content: "同意将xx的状态由xx变为xx")
  end

  def update_result path
    update_attributes(path: path)
  end
end
