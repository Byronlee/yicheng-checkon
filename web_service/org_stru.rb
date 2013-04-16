require "#{File.dirname(__FILE__)}/utils"
require "#{File.dirname(__FILE__)}/access_oracle"

class OrgStru

  attr_reader :user_attr_key,:dept_attr_key

  def initialize
    @qd = QueryData.new
    @config = LoadConfigFile() 

    @user_attr_key = ["SU_USER_ID","SU_NICKNAME_CODE","SU_NICKNAME_DISPLAY","SU_PHONE_NUM","SU_USERNAME","SU_USER_NO","SU_DEPT_ID"]
    @dept_attr_key = ["SD_DEPT_CODE","SD_DEPT_NAME"]
    @registrar_post_id  = "402880fb3d66f0c5013d66f6a1c2003d"
    @approval_depa_id = "4028809b3c6fbaa7013c6fbc39900352"
  end

  def fetch_one_user(field,value)
    user = @qd.select_one_as_map('SYS_USER',@user_attr_key,field,value)
    user["SU_USER_NO"] = '0'+user["SU_USER_NO"] if user.has_key? "SU_USER_NO"
    user 
  end

  def user_attr(user_id)
    fetch_one_user "SU_USER_ID",user_id
  end
  
  def user(user_nickname)
    fetch_one_user "SU_NICKNAME_CODE",user_nickname
  end

  def user_attr_ext(user)
    return {} if user.nil? or user.empty?
    ext_attrs = {}
    ancestors = dept_ancestors(user["SU_DEPT_ID"])
    ancestors_names = ancestors.map { |dept_id| dept_attr(dept_id) ["SD_DEPT_NAME"] }
    ext_attrs["SD_DEPT_NAME"] = dept_attr(user["SU_DEPT_ID"])["SD_DEPT_NAME"]
    ext_attrs["DEPT_ANCESTORS"] = ancestors.zip(ancestors_names)
    posts = user_posts(user["SU_USER_ID"])
    ext_attrs["POSTS"] = posts.zip(post_names(posts))
    return ext_attrs
  end


  def dept_attr(dept_id)
    @qd.select_one_as_map('SYS_DEPT',@dept_attr_key,"SD_DEPT_ID",dept_id)
  end

  def dept_ancestors(dept_id)
    node = org_tree.search dept_id
    return [] if node.nil? 
    node.parentage.map {|node| node.name} .reverse() [1..-1]
  end
  
  def dept_users(dept_id)
    @qd.query_field_to_array("SELECT SU_USER_ID FROM SYS_USER WHERE SU_DEPT_ID = '#{dept_id}'")
  end

  def dept_users_with_subdept(dept_id)
    result = []
    dept_tree(dept_id).each do |dept_node|  
      dept_node_id = dept_node.content[:id]
      result.concat(dept_users(dept_node_id))
    end
    result 
  end

  def dept_users_with_attr(dept_id)
    dept_users(dept_id).map { |user_id| user_attr user_id }
  end

  def dept_list
    @qd.query_field_to_array("SELECT SD_DEPT_ID FROM SYS_DEPT")
  end


  def produce_org_tree
    return if @org_tree # tree not nil 
    tree_table = []
    @qd.query("SELECT SD_DEPT_ID,SD_PARENT_DEPT_ID,SD_DEPT_CODE,SD_DEPT_NAME FROM SYS_DEPT ") do |row|
      tree_table << {:id=>row[0],:pid=>row[1],:data=>row}
    end
    @org_tree = Tree::TreeNode.produce_tree(tree_table)    
    # @qd.LOG(@org_tree.to_json)
  end 

  def produce_tree_to_map(tree_node)
    return nil unless tree_node.class == Tree::TreeNode
    result = {}
    data = tree_node.content[:data]
    if data.is_a? Array then
      result = Hash[[:id,:pid,:code,:name].zip data]
    end
    if tree_node.has_children? then
      result[:children] = tree_node.children.map {|e| produce_tree_to_map e}
    end
    # @qd.LOG(result.to_s)
    return result
  end

  def produce_tree_to_json(tree_node) 
    JSON.dump(produce_tree_to_map tree_node)
  end

  def org_tree
    produce_org_tree unless @org_tree
    @org_tree
  end

  def dept_tree(dept_id=nil)
    if dept_id.nil? then
      org_tree
    else
      org_tree.search dept_id
    end
  end
  
  def attend_tree(user_id)
    ## ....TODO....
    user = user_attr user_id
    dept_id = user["SU_DEPT_ID"]
    tree = produce_tree_to_map (dept_tree dept_id)
    tree[:staffs] = dept_users(dept_id)
    tree 
  end

  def post_map
    @qd.select_table_as_map "SYS_POST","SP_POST_ID","SP_POST_NAME"
  end

  def user_posts(user_id)
    @qd.query_field_to_array("SELECT SURP_POST_ID FROM SYS_USER_R_POST WHERE SURP_USER_ID='#{user_id}'")
  end

  def post_names(post_list)
    @post_map = post_map if @post_map.nil?
    post_list.map { |post_id| @post_map[post_id] }
  end

  def registrars
    @qd.query_field_to_array("SELECT SURP_USER_ID FROM SYS_USER_R_POST WHERE SURP_POST_ID = '#{@registrar_post_id}'")
  end

  def registrar?(user_id)
    @qd.query_not_empty "SELECT SURP_USER_ID FROM SYS_USER_R_POST WHERE SURP_POST_ID = '#{@registrar_post_id}' and SURP_USER_ID='#{user_id}'"
  end

  def approval?(user_id)
    @qd.query_not_empty "SELECT SU_USER_ID FROM SYS_USER WHERE SU_DEPT_ID= '#{@approval_depa_id}' and SU_USER_ID='#{user_id}'" 
  end
end

