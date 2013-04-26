# -*- coding: utf-8 -*-
require "utils"
require "access_db"
require "access_mongo"

require "date"

class OrgStru

  attr_reader :user_attr_key,:dept_attr_key

  def initialize
    @config = LoadConfigFile() 

    @log = Logger.new(@config.fetch('logger_file',"#{File.dirname(__FILE__)}/../ws.log"))
    @log.level = GetLogLevel(@config.fetch('logger_level','warn'))

    @qd = QueryData.new(@config,@log)

    @mcache = MongoCache.new(@config['mongo'])

    @user_attr_key = @config["table"]["user"] 
    @dept_attr_key = @config["table"]["dept"] 

    @attend_scope = @config["attend"]["scope"]

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

  def search_user(keyword)
    if keyword =~ /\d+/
      keyword = keyword[1..-1] if  keyword[0] = "0"
      sql_string = "SELECT SU_USER_ID FROM SYS_USER where SU_USER_NO = '#{keyword}'"
    elsif keyword =~ /^[-\w.]+$/
      sql_string = "SELECT SU_USER_ID FROM SYS_USER where SU_NICKNAME_CODE like '#{keyword}%'"
    elsif keyword =~ /^\p{Han}+\w*$/
      sql_string = "SELECT SU_USER_ID FROM SYS_USER where SU_NICKNAME_DISPLAY like '#{keyword}%' or SU_USERNAME like '#{keyword}%'"
    else
      return []
    end
    @qd.query_field_to_array(sql_string)
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

  def dept_users?(dept_id,user_id)
    user_dept = user_attr(user_id)["SU_DEPT_ID"]
    return false if user_dept.nil? 
    (user_dept == dept_id) or (dept_ancestors(user_dept).include? dept_id)
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
    scope_dept_id = registrar_attend_scope user_id
    return nil if scope_dept_id.nil?
    produce_tree_to_map (dept_tree scope_dept_id)
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

  def role_posts(role)
    @config["attend"]["role_#{role.to_s}_posts"]
  end 

  def have_roles?(role,user_id)
    return approval? user_id if role==:approval 
    posts = role_posts(role)
    return false if posts.nil?
    not (user_posts(user_id) & posts).empty?
  end

  def users_with_role(role,dept_id)
    # dept_users_with_subdept(dept_id).select{|user| have_roles?(role, user) }
    all_users_with_role(role).select{|user| dept_users?(dept_id,user)}
  end

  def all_users_with_role(role)
    posts = role_posts(role).join("','")
    return [] if posts.empty?
    @qd.query_field_to_array("SELECT SURP_USER_ID FROM SYS_USER_R_POST WHERE SURP_POST_ID in ('#{posts}')") 
  end
  
  def registrar_attend_scope(registrar_id)
    return nil unless have_roles?(:registrar,registrar_id)

    registrar_dept_id = user_attr(registrar_id)["SU_DEPT_ID"]
    registrar_ancestors = dept_ancestors(registrar_dept_id)

    up_scope = registrar_ancestors & @attend_scope
    return nil if up_scope.empty?
    
    scope_id =  registrar_ancestors.index(up_scope.first)+1
    # registrar department_id is no including ancestors
    # So if scope_id out of ancestors,return registrar's department id 
    if scope_id == registrar_ancestors.length 
      return registrar_dept_id
    else 
      return registrar_ancestors[scope_id]
    end
  end

  def approval?(user_id)
    @qd.query_not_empty "SELECT SU_USER_ID FROM SYS_USER WHERE SU_DEPT_ID= '#{@approval_depa_id}' and SU_USER_ID='#{user_id}'" 
  end

  def tempreg_mongo_collection
    @mcache.collection_tempreg
  end

  def tempreg_peroid(user_id)
    tempreg_mongo_collection.find("user_id" => user_id).to_a.first
  end

  def tempreg_peroid_remove(user_id)
    tempreg_mongo_collection.remove("user_id" => user_id)
  end

  def temp_registrar_rights_peroid(user_id,peroid=nil)
    saved_tempreg = tempreg_peroid user_id
    if peroid.nil? 
      return nil if saved_tempreg.nil?
      {
        :begin => saved_tempreg["begin"].to_date,
        :end => saved_tempreg["end"].to_date 
      }
    else
      if peroid.has_key? :begin and peroid.has_key? :end
        doc = {
          :user_id => user_id,
          :begin => Date2UTC(peroid[:begin]),
          :end => Date2UTC(peroid[:end])
        } 

        if saved_tempreg.nil? 
          tempreg_mongo_collection.insert(doc)
        else
          tempreg_mongo_collection.update({"_id" => saved_tempreg["_id"]},doc)
        end
      ##else ??
      end
    end
  end
  
 
  def temp_registrars(user_id)
    return [] unless have_roles? :registrarsman,user_id
    
    scope_id = registrar_attend_scope user_id
    return [] if scope_id.nil?
    temp_regs = users_with_role(:tempregistrar,scope_id)
    temp_regs.map do |temp_reg_id|
      peroid = temp_registrar_rights_peroid(temp_reg_id)
      today = Date.today
      peroid ? 
      {
        :user_id => temp_reg_id,
        :state => (peroid[:begin]<=today and today <= peroid[:end]),
        :peroid => peroid 
      }:{
        :user_id => temp_reg_id,
        :state => false
      }
    end
  end

end
