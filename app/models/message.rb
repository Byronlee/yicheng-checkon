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
  field :decision , type: String , default: 'agree'


 class Message < Strust.new(:launcher , :remark,:checkins)
end


  default_scope where(is_view: false) 

  def self.new_message params
     create!(:launcher =>  User.current_user.staffid ,
             :receiver =>  params[:receiver], 
             :checkins => params[:checkins] || params[:record].values.first,
             :record_id => params[:record_id] ,
             :remark   => params[:remark],
             :decision  => params[:decision]
             )
  end

  def self.launch? params
    record = StaffRecord.find(params[:record_id])
    if StaffRecord.is_change?(record ,params)
      record.apply
      new_message params
      true
    else
      false
    end
  end

  def self.reply params
     message = find(params[:message_id])
     record =  StaffRecord.find(message.record_id)
     record.approval
     new_message( receiver: message.launcher,
                  checkins: message.checkins,
                  record_id: message.record_id,
                  remark: params[:remark],
                  decision: params[:decision])

     message.view

    if params[:decision].eql?("agree") 
      message.checkins.map  do |check_unit_id , behave_id|
        record.checkins.find_by(check_unit_id: check_unit_id).update_attribute(:behave_id ,behave_id)
      end
    end
  end

  def self.registrar
    where(receiver: User.current_user.staffid)
  end

  def self.approval
    where(receiver: "approval")
  end

  def view
    update_attributes(is_view: true)
  end
end
