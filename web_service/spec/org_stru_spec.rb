# -*- coding: utf-8 -*-
require "#{File.dirname(__FILE__)}/../org_stru"

describe OrgStru do
  before do
    @orgstru = OrgStru.new  
    @test_data_user_id = "4028809b3c6fbaa7013c6fbc3db41bc3"
    @test_data_user_id_approval = "4028809b3c6fbaa7013c6fbc3da51a13"
    @test_data_dept_id = "4028809b3c6fbaa7013c6fbc39900380"
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
    user  = @orgstru.user_attr @test_data_user_id
    user.class.should eq Hash
    @orgstru.user_attr_key.each do |f|
      user.has_key?(f).should be_true
    end
    user["SU_NICKNAME_CODE"].should eq "cangnan"
    user["SU_USERNAME"].should eq "廖玥"
	user["SU_USER_NO"].should eq "072016350"

    @orgstru.user_attr("id.err").should be_empty 
  end

  it "根据给出的部门ID返回部门的属性,如果ID不正确返回空" do
    dept = @orgstru.dept_attr @test_data_dept_id 
    dept.class.should eq Hash
    @orgstru.dept_attr_key.each do |f|
      dept.has_key?(f).should be_true
    end
    dept["SD_DEPT_CODE"].should eq "0407"
    dept["SD_DEPT_NAME"].should eq "三圣区"
    @orgstru.dept_attr("errid").should be_empty
  end

  it "根据给出的部门ID返回某个部门下属所有用户" do
    users = @orgstru.dept_users @test_data_dept_id
    users.should_not be_empty
  end



  it "根据给出的部门ID返回某个部门下属所有用户以及其用户属性" do
    users_with_attr = @orgstru.dept_users_with_attr @test_data_dept_id
    users_with_attr.should_not be_empty
    users_map =  users_with_attr.inject({}) do |m,user|
      m[user["SU_NICKNAME_CODE"]]= user["SU_USERNAME"] 
      m ##
    end
    users_map["cangnan"].should eq "廖玥"
  end

  it "根据文员ID返回考勤树组织结构树" do
    @orgstru.have_roles?(:registrar,@test_data_user_id).should be_true
    tree_map = @orgstru.attend_tree @test_data_user_id
    tree_map[:children].should_not be_empty
    tree_map[:id].should eq @test_data_dept_id
    tree_map[:name].should eq "三圣区" 
    tree_map[:staffs].should include @test_data_user_id # 应该包含自己
  end

  it "返回所有部门的列表" do
    dept_array = @orgstru.dept_list 
    dept_array.length.should eq @dept_count
    dept_array.should include  @test_data_dept_id
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
    @orgstru.user_posts(@test_data_user_id).should include @post_qu_wy_id
  end

  it "列出某部门以及下属部门所有员工" do
    users = @orgstru.dept_users_with_subdept @test_data_dept_id
    users.should_not be_empty
    # TODO : More Test
  end

  it "测试返回所有的考勤者" do 
    registrars = @orgstru.all_users_with_role(:registrar)
    registrars.should include @test_data_user_id
    registrars.length.should > 2
    registrars = @orgstru.users_with_role(:registrar,@test_data_dept_id)
    registrars.should include @test_data_user_id
  end

  it "测试店文员考勤范围" do 
    ##TODO...
  end

  it "角色测试" do 
     @orgstru.have_roles?(:registrar,@test_data_user_id).should be_true
     @orgstru.have_roles?(:registrar,@test_data_user_id_approval).should_not be_true
     @orgstru.approval?(@test_data_user_id).should_not be_true
     @orgstru.approval?(@test_data_user_id_approval).should be_true
  end
 
  # it "pretty_tree显示所有部门树" do
  #   tree_str  = @orgstru.dept_tree.pretty_tree
  #   tree_str.should_not be_empty
  #   print tree_str
  # end

end
