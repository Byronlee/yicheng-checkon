# -*- coding: utf-8 -*-
class ModifyLog 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :raw_behave , type:String
  field :apply_user , type:String
  field :apply_date , type:String ,default: Date.today.to_s
  field :state      , type:String ,default: "applying"   # 三种状态： applying , refuse ，pass
  field :apply_reason, type:String  

  field :approval_user , type:String 
  field :latest_behave , type:String
  field :approval_date , type:String
  field :approval_remark , type:String

  belongs_to :record
  belongs_to :check_unit
  belongs_to :behave


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
