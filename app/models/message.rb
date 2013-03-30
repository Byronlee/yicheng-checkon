# -*- coding: utf-8 -*-
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :launcher ,tyoe:String
  field :receiver, type:String
  field :remark, type:String  

  field :record_id , type:String
  field :is_view , type:Boolean ,default:  false


  field :result ,type:String

  

  embeds_many :checkins
  belongs_to  :staff_record

  after_create do | modify_record |
  #    modify_record.apply_user = User.resource(modify_record.apply_user) if  modify_record.apply_user.class == "String"
  #    modify_record.approval_person ||=  User.resource(modify_record.approval__user) if modify_record.approval_user
  end

  def self.new_mr params
     create!(:raw_behave => params[:raw_behave] ,
             :apply_user =>  User.current_user.staffid , #"4028809b3c6fbaa7013c6fbc3c3e0651" ,
             :apply_date => Date.today.to_s , 
             :latest_behave => params[:latest_behave],
             :apply_reason => params[:apply_reason])
  end



  def  self.approval params
     find_by(id: params[:mid]).update_attributes(approval_user: User.current_user.staffid,
                                                 approval_date: Date.today.to_s ,
                                                 approval_remark: params[:remark],
                                                 state: params[:decide] )
  end

 
end
