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


 
end
