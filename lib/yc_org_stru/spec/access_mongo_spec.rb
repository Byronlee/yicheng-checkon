# -*- coding: utf-8 -*-
require 'yaml'
require "#{File.dirname(__FILE__)}/../lib/org_stru/utils"
require "#{File.dirname(__FILE__)}/../lib/org_stru/access_mongo"


describe MongoCache do
  before do
    config  = YAML.load_file("#{File.dirname(__FILE__)}/../../../config/settings.yml")["test"]["yc_org_stru"]['mongo']  
    @mcache = MongoCache.new(config)
  end

  it "测试Mongo连接" do
    @mcache.connected?.should be_true
  end
  
  it "测试Mongo访问" do 
    doc = {"name" => "MongoDB", "type" => "database", "count" => 1, "info" => {"x" => 203, "y" => '102'}}
    coll = @mcache.collection_testcoll
    id = coll.insert(doc)
    id.should_not equal nil
    find_result = coll.find("type" => "database").to_a
    find_result.should_not be_empty
    find_result[0]["name"].should eq "MongoDB"
    coll.remove("name" => "MongoDB")
    coll.find("type" => "database").to_a.should be_empty
    coll.count.should eq 0

    cant_find_result = coll.find("type" => "122334").to_a
    cant_find_result.class.should eq Array
    cant_find_result.should be_empty

    coll.drop
  end
  
end
