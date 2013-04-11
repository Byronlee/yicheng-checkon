# -*- coding: utf-8 -*-
require 'logger'
require 'tree'
require 'json'
require 'yaml'

module Tree
  class TreeNode
    def search(id)
      if block_given? then
        each do |node|
          return node if yield node,id  
        end
      else
        each do |node|
          return node if node.name == id  
        end
      end
      return nil 
    end

    class << self
      def produce_tree (tree_table)
        ## tree_table is a Array . Every element is a map hasing key :id,:pid,:data
        checked_array = tree_table.select {|e| e.has_key? :id and e.has_key? :pid and e[:id]!=e[:pid] }

        sub_nodes,root_nodes = checked_array.partition do |e|
          checked_array.find {|x| x[:id] == e[:pid] }
        end 
        
        v_root_node  = Tree::TreeNode.new("",{:id=>""})
        root_nodes.each{|e| v_root_node << Tree::TreeNode.new(e[:id],e)}

        Tree::TreeNode._array_to_tree(v_root_node,sub_nodes)
        return v_root_node
      end

      def _array_to_tree(treenode,array)
        no_parent = []
        array.each do |e|
          node = treenode.search(e){|x,y|x.name == y[:pid] }
          if node then
            node << Tree::TreeNode.new(e[:id],e)
          else
            no_parent << e
          end
        end
        Tree::TreeNode._array_to_tree treenode,no_parent unless no_parent.size == 0  
      end
    end 
  end 
end


class QueryData

  def logout
    exit unless @connect 
    if @connect_name=='sqlite' then 
      @connect.close 
      @log.info("SQLite disconnected")
    else 
      @connect.logout 
      @log.info("Oracle disconnected")
    end
  end

  def initialize(connect_name = 'oracle' )
    ObjectSpace.define_finalizer(self, proc{method(:logout).call} )

    default_logfile = "#{File.dirname(__FILE__)}/../ws.log"
    config_file = "#{File.dirname(__FILE__)}/../config/ws_config.yaml"

    if  File.exist? config_file
      @config = YAML.load_file config_file
      default_logfile = @config['logger_file'] if @config['logger_file'] 
    else
      @config = {}
    end
    @log = Logger.new(default_logfile)
    @connect_name = @config['default_connect'] unless @config['default_connect'].nil?
    connect_to_server 
  end
                                 
  def connect_name
    @connect_name
  end
                                   
  def LOG(s)
    @log.info(s)
  end 

  def server_connected?
    not @connect.nil?
  end 

  def connect_to_server 
    @connect = nil

    if @connect_name == 'sqlite' then
      require 'sqlite3'
      db_file = @config['connect']['sqlite']['db']
      db_file = 'ref/test_data.db' if db_file.nil?
      db = File.expand_path(db_file,"#{File.dirname(__FILE__)}/../")
      if File.exist? db then
        @connect = SQLite3::Database.new(db)
        @log.info("SQLite '#{db}' is connected")
      else
        @log.error("SQLite db file '#{db}' is not exist")
      end  
    else
      oracle_connnect_conf = @config['connect'][@connect_name]
      if oracle_connnect_conf.nil? 
        @log.error("Oracle config '#{@connect_name}' is not exist")
      end

      require 'oci8'

      tns = "(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP) (HOST = #{oracle_connnect_conf['host']})(PORT = #{oracle_connnect_conf['port']}))) (CONNECT_DATA = (SID = #{oracle_connnect_conf['sid']})))"
      
      begin   
        @connect = OCI8.new(oracle_connnect_conf['useername'],
                         oracle_connnect_conf['password'],
                         tns)
      rescue => ex
        @connect = nil 
        @log.error("Connect Oracle Server fail :#{ex}")
      end
    end
  end
  
  
  def query(sql_string,&block)
    return unless @connect 
    begin
      @log.debug("SQL exec:#{sql_string}")
      if @connect_name == 'sqlite' then
        @connect.execute(sql_string,&block)
      else
        @connect.exec(sql_string,&block)
      end
      @log.debug("SQL exec success")
    # rescue StandardError => oe 
    #   @log.error("Query Error: #{sql_string} . #{oe}")
    rescue => ex
      @log.error("Query Error: #{sql_string} . #{ex}")
    end
  end
  
  def query_not_empty(string)
    query(string) do |_|
      return true 
    end
    return false
  end

  def query_field_to_array(sql_string)
    result = []
    query(sql_string){|row| result << row[0] }
    result 
  end

  def select_table_as_map(table_name,key_field,value_field)
    return {} unless @connect 
    sql_string = "SELECT #{key_field},#{value_field} FROM #{table_name}"
    result = {}
    query("SELECT #{key_field},#{value_field} FROM #{table_name}" ) do |row|
      result[row[0]] = row[1] 
    end
    result 
  end


  def select_one_as_map(table_name,fields,key,value)
    return {} unless @connect
    if value.is_a? String then
      value_str = "'#{value}'"
    else
      value_str = value.to_s
    end
    sql_string = "SELECT #{fields.join(',')} FROM #{table_name} where #{key}=#{value_str}"
    @log.debug("Fetch first :#{sql_string}")
    if @connect_name == 'sqlite' then
      row = @connect.get_first_row(sql_string) 
    else
      row = @connect.select_one(sql_string)
    end
    @log.debug("Fetch first success")
    return {} if row.nil? 
    Hash[fields.zip(row)]
  end
end

class OrgStru

  attr_reader :user_attr_key,:dept_attr_key

  def initialize
    @qd = QueryData.new
    @user_attr_key = ["SU_USER_ID","SU_NICKNAME_CODE","SU_NICKNAME_DISPLAY","SU_PHONE_NUM","SU_USERNAME","SU_USER_NO","SU_DEPT_ID"]
    @dept_attr_key = ["SD_DEPT_CODE","SD_DEPT_NAME"]
    @registrar_post_id  = "402880fb3d66f0c5013d66f6a1c2003d"
    @approval_depa_id = "4028809b3c6fbaa7013c6fbc39900352"
  end

  def user_attr(user_id)
    @qd.select_one_as_map('SYS_USER',@user_attr_key,"SU_USER_ID",user_id)
  end
  
  def user(user_nickname)
    @qd.select_one_as_map('SYS_USER',@user_attr_key,"SU_NICKNAME_CODE",user_nickname)
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
  

  def user_dept_tree(user_id)
    user = user_attr user_id
    dept_tree user["SU_DEPT_ID"]
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

