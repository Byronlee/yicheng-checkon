# -*- coding: utf-8 -*-
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :launcher ,type:String
  field :receiver ,type:String
  field :remark, type:String  

#  field :record_id , type:String
  field :is_view , type:Boolean ,default:  false
  field :decide  , type:String

 
  embeds_many :checkins
  

  after_create do |message|

  end

  def self.new_message params
     create!(:launcher =>  User.current_user.staffid ,
             :receiver =>  params[:launcher], 
             :remark   => params[:remark],
             :decide   => params[:decide]
             )
  end



  def self.message p
    record = StaffRecord.find(p[:record_id])
    str = ""
    p[:record].each do |uid,checkins|
      str = "将#{record.staff_name}在#{record.created_date}"
      checkins.map do |unit_id,behave_id|
        o_behave = record.checkins.find_by(check_unit_id: unit_id).behave.name
        str << CheckUnit.find(unit_id).name+"的考勤由#{o_behave}变为"
        str << Behave.find(behave_id).name
      end
    end
    str

end
