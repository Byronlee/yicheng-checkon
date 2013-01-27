# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter CASClient::Frameworks::Rails::Filter



  def resources
    @meili={"meili1" => [{"staffid"=>"425645",
                  "position"=>"经济人＿售",
                   "group_name"=>"魅力１",
                   "name"=>"张三"
                 },
                 {"staffid"=>"4３12623",
                  "position"=>"经济人＿售",
                   "group_name"=>"魅力１",
                   "name"=>"夏某"
                 },
                 {"staffid"=>"42３5645",
                  "position"=>"高级经济人＿售",
                   "group_name"=>"魅力１",
                   "name"=>"李某"
                 },
                 {"staffid"=>"425２645",
                  "position"=>"经济人",
                   "group_name"=>"魅力１",
                   "name"=>"张某"
                 },
                 {"staffid"=>"4256１45",
                  "position"=>"见习经济人",
                   "group_name"=>"魅力１",
                   "name"=>"王五"
                 },
                 {"staffid"=>"4255",
                  "position"=>"见习经济人＿售",
                   "group_name"=>"魅力１",
                   "name"=>"李四"
                 }
               ]
    }

  end
  # meili={:meili1 => [{:staffid =>"425645",
  #                     :position =>"经济人＿售",
  #                     :name =>"张三"
  #                     },
  #                    {"staffid"=>"4３12623",
  #                     "position"=>"经济人＿售",
  #                     "name"=>"夏某"
  #                    },
  #                 {"staffid"=>"42３5645",
  #                  "position"=>"高级经济人＿售",
  #                   "name"=>"李某"
  #                 },
  #                 {"staffid"=>"425２645",
  #                  "position"=>"经济人",
  #                   "name"=>"张某"
  #                 },
  #                 {"staffid"=>"4256１45",
  #                  "position"=>"见习经济人",
  #                   "name"=>"王五"
  #                 }，
  #                 {"staffid"=>"425345",
  #                  "position"=>"见习经济人＿售",
  #                   "name"=>"李四"
  #                 }
  #               ]
  #     ]













end
