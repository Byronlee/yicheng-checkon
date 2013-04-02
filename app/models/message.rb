# -*- coding: utf-8 -*-
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :launcher ,type:String
  field :receiver ,type:String
  field :checkins ,type:Hash

  field :record_id , type:String
  field :remark, type:String  
  field :is_view , type:Boolean ,default:  false


  def self.new_message params
     create!(:launcher =>  User.current_user.staffid ,
             :receiver =>  params[:launcher], 
             :checkins => params[:record].values.first ,
             :record_id => params[:record_id] ,
             :remark   => params[:remark]
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

end
