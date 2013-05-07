# -*- coding: utf-8 -*-
require 'yaml'
require "#{File.dirname(__FILE__)}/../lib/org_stru"

describe OrgStru do
  before do
    config  = YAML.load_file("#{File.dirname(__FILE__)}/../../../config/settings.yml")["test"]["yc_org_stru"]
    @orgstru = OrgStru.new (config)
    @tempreg =  TempRegistratorLimitation.new(config)

    @test_user_id = "4028809b3c6fbaa7013c6fbc3db41bc3"
    @test_user_id_registrar = "4028809b3c6fbaa7013c6fbc3da51b48"
    @test_user_id_approval = "4028809b3c6fbaa7013c6fbc3da51a13"
    @test_dept_id = "4028809b3c6fbaa7013c6fbc39900380"
    @test_dept_ancestor1 = ["4028809b3c60dcc8013c60e107810001",
                            "4028809b3c6fbaa7013c6fbc39510002",
                            "4028809b3c6fbaa7013c6fbc39700120",
                            "4028809b3c6fbaa7013c6fbc39700122"]
    @test_dept_ancestor2 = ["4028809b3c60dcc8013c60e107810001",
                            "4028809b3c6fbaa7013c6fbc39510002",
                            "4028809b3c6fbaa7013c6fbc39700129",
                            "4028809b3c6fbaa7013c6fbc3970012a"]

    @dept_count = 1001
    @post_count = 76
    @post_qu_wy_id = "402880fb3d66f0c5013d66f6a1c2003d"
    @post_qu_wy_name = "区域文员"


  end

  it "根据给出的用户id返回用户属性,如果id不正确返回空" do
    user  = @orgstru.user_attr @test_user_id
    user.class.should eq Hash
    @orgstru.user_attr_key.each do |f|
      user.has_key?(f).should be_true
    end
    user["SU_NICKNAME_CODE"].should == "cangnan"
    user["SU_USERNAME"].should == "廖玥"
	user["SU_USER_NO"].should == "072016350"

    @orgstru.user_attr("id.err").should be_empty 
  end

  it "根据给出的部门ID返回部门的属性,如果ID不正确返回空" do
    dept = @orgstru.dept_attr @test_dept_id 
    dept.class.should eq Hash
    @orgstru.dept_attr_key.each do |f|
      dept.has_key?(f).should be_true
    end
    dept["SD_DEPT_CODE"].should == "0407"
    dept["SD_DEPT_NAME"].should == "三圣区"
    @orgstru.dept_attr("errid").should be_empty
  end

  it "根据给出的部门ID返回某个部门下属所有用户" do
    users = @orgstru.dept_users @test_dept_id
    users.should_not be_empty
  end



  it "根据给出的部门ID返回某个部门下属所有用户以及其用户属性" do
    users_with_attr = @orgstru.dept_users_with_attr @test_dept_id
    users_with_attr.should_not be_empty
    users_map =  users_with_attr.inject({}) do |m,user|
      m[user["SU_NICKNAME_CODE"]]= user["SU_USERNAME"] 
      m ##
    end
    users_map["cangnan"].should == "廖玥"
  end

  it "根据文员ID返回考勤树组织结构树" do
    @orgstru.have_roles?(:registrar,@test_user_id).should be_true
    tree_map = @orgstru.attend_tree @test_user_id
    tree_map[:children].should_not be_empty
    tree_map[:id].should == @test_dept_id
    tree_map[:name].should == "三圣区" 
  end

  it "返回所有部门的列表" do
    dept_array = @orgstru.dept_list 
    dept_array.length.should == @dept_count
    dept_array.should include  @test_dept_id
  end 

  it "返回部门的祖先列表" do 
    dept_id = @test_dept_ancestor1.pop 
    @test_dept_ancestor1.should eq @orgstru.dept_ancestors dept_id
    dept_id = @test_dept_ancestor2.pop 
    @test_dept_ancestor2.should eq @orgstru.dept_ancestors dept_id
  end

  it "返回所有职位Hash" do
    post_map = @orgstru.post_map 
    post_map.length.should eq @post_count
    post_map[@post_qu_wy_id].should eq  @post_qu_wy_name
  end 

  it "获取某个员工的职位ID列表" do 
    @orgstru.user_posts(@test_user_id).should include @post_qu_wy_id
  end

  it "列出某部门以及下属部门所有员工" do
    users = @orgstru.dept_users_with_subdept @test_dept_id
    users.should_not be_empty
    # TODO : More Test
  end

  it "测试返回所有的考勤者" do 
    registrars = @orgstru.all_users_with_role(:registrar)
    registrars.should include @test_user_id
    registrars.length.should > 2
  end

  it "测试返回某一个部门的考勤者" do 
    registrars = @orgstru.users_with_role(:registrar,@test_dept_id)
    registrars.should include @test_user_id
    registrars.should include @test_user_id_registrar
  end

  it "测试店文员的考勤范围" do
    reg_dept_id = @orgstru.user_attr(@test_user_id_registrar)["SU_DEPT_ID"]
    reg_dept_id.should eq "4028809b3c6fbaa7013c6fbc39900383"
    scope_dept_id = @orgstru.registrar_attend_scope (@test_user_id_registrar)
    scope_dept_id.should eq @test_dept_id
  end

  it "测试可考勤者[经理]" do 
    # {"SU_USER_ID":"4028809b3c6fbaa7013c6fbc3da51b47","SU_NICKNAME_CODE":"shuijing.ssq","SU_NICKNAME_DISPLAY":"水镜","SU_PHONE_NUM":"18908208532","SU_USERNAME":"余跃","SU_USER_NO":"010023110","SU_DEPT_ID":"4028809b3c6fbaa7013c6fbc39900382","SD_DEPT_NAME":"海棠2","DEPT_ANCESTORS":[["4028809b3c60dcc8013c60e107810001","伊诚地产"],["4028809b3c6fbaa7013c6fbc39510002","成都伊诚"],["4028809b3c6fbaa7013c6fbc39900359","【东南区】"],["4028809b3c6fbaa7013c6fbc39900380","三圣区"]],"POSTS":[["402880fb3d66f0c5013d66f6a1c20006","店经理"]]}                         
    dept_scope = @orgstru.registrar_attend_scope(@test_user_id)

    tr = @orgstru.users_with_role(:tempregistrar,dept_scope) 

    tr.should_not be_empty

    tr.should include "4028809b3c6fbaa7013c6fbc3da51b47" 

    find_a_manager = tr.select {|m| @tempreg.peroid(m).nil? }.first
    # 只能设置为明天有权限
    @tempreg.set_peroid(find_a_manager,:begin => Date.today+1,:end => Date.today+1)
    read_back = @tempreg.peroid(find_a_manager)
    read_back[:begin].should == (Date.today+1)
    read_back[:end].should == (Date.today+1)

    @tempreg.set_peroid(find_a_manager,:begin => Date.today,:end => Date.today+1)
    @tempreg.peroid(find_a_manager).should == nil 

    @tempreg.remove(find_a_manager)
    
  end

  it "角色测试" do 
     @orgstru.have_roles?(:registrar,@test_user_id).should be_true
     @orgstru.have_roles?(:registrar,@test_user_id_approval).should_not be_true
     @orgstru.approval?(@test_user_id).should_not be_true
     @orgstru.approval?(@test_user_id_approval).should be_true
  end
 
end
