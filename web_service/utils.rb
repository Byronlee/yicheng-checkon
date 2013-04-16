require 'tree'

def GetLogLevel (level_str)
  log_level_table = {
    'FATAL'=>Logger::FATAL,
    'ERROR'=>Logger::ERROR ,
    'WARN'=>Logger::WARN ,
    'INFO'=>Logger::INFO ,
    'DEBUG'=>Logger::DEBUG ,
  }
  level_str.upcase!
  if log_level_table.has_key? level_str 
    return log_level_table[level_str]
  else
    return Logger::WARN
  end
end

def LoadConfigFile
  dir_list = ["#{File.dirname(__FILE__)}/../config/",
              "/etc/yicheng/",
              "/etc/"]
  file_name = "ws_config.yaml"
  dir_list.each do |dir|
    config_file = dir+file_name
    if  File.exist? config_file
      return YAML.load_file config_file
    end
  end
  raise "Can't found the config file #{file_name} in the following directory:\n"+dir_list.join("\n")
end

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
