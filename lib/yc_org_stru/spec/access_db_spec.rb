# coding: utf-8 

require 'logger'
require "#{File.dirname(__FILE__)}/../lib/org_stru/utils"
require "#{File.dirname(__FILE__)}/../lib/org_stru/access_db"


describe QueryData do
  before do
    config  = LoadConfigFile()
    @qd = QueryData.new(config)
  end

  it "现在使用的是sqlite" do 
    @qd.connect_name.should eq 'sqlite'
  end

  it "即便错误的配置也不能抛出异常,只能写日志" do
    if @qd.connect_name != 'sqlite'
      expect { QueryData.new(:test_expection).connect_to_server }.to_not raise_error
    end
  end

  it "测试数据库连接" do
    @qd.connected?.should be_true
  end
  
  it "测试数据库访问" do
    tables = []
    if @qd.connect_name == 'sqlite'
      @qd.query("SELECT * FROM sqlite_master"){|row| tables << row }
    else
      @qd.query("select TABLE_NAME from all_tables"){|row| tables << row }
    end
    tables.should_not be_empty 
  end 

  it "即便错误的SQL也不能抛出异常,只能写日志" do
    expect { @qd.query("select TABLE_NAME all_tables")}.to_not raise_error
  end
end


