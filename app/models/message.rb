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
  default_scope where(is_view: false) 

  def self.new_message params
     create!(:launcher =>  User.current_user.staffid ,
             :receiver =>  params[:receiver], 
             :checkins => params[:checkins] || params[:record].values.first ,
             :record_id => params[:record_id] ,
             :remark   => params[:remark],
             :decision  => params[:decision]
             )
  end

  def self.launch params
    StaffRecord.find(params[:record_id]).apply
    new_message params
  end

  def self.reply params
     message = find(params[:message_id])
     StaffRecord.find(message.record_id]).approval
     new_message( receiver: message.launcher,
                  checkins: message.checkins,
                  record_id: message.record_id,
                  remark: params[:remark],
                  decision: params[:decision])
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
