# -*- coding: utf-8 -*-
require 'logger'
require 'yaml'
require "#{File.dirname(__FILE__)}/utils"


class QueryData

  def logout
    return unless connected?
    if @connect_name=='sqlite' then 
      @connect.close 
      @log.info("SQLite disconnected")
    else 
      @connect.logout 
      @log.info("Oracle disconnected")
    end
  end


  def initialize(connect_name = 'oracle')
    ObjectSpace.define_finalizer(self, proc{method(:logout).call} )

    @config = LoadConfigFile() 
    
    default_logfile = @config.fetch('logger_file',"#{File.dirname(__FILE__)}/../ws.log")
    @log = Logger.new(default_logfile)
    @log.level = GetLogLevel(@config['logger_level'])

    @connect_name = @config['default_connect'] unless @config['default_connect'].nil?

    connect_to_server 
  end
                                 
  def connect_name
    @connect_name
  end
                                   
  def LOG(s)
    @log.info(s)
  end 

  def connected?
    not @connect.nil?
  end 

  def connect_to_server 
    logout 
    @connect = nil

    if @connect_name == 'sqlite' then
      require 'sqlite3'
      db_file = @config['connect']['sqlite']['db']
      db_file = 'ref/test_data.db' if db_file.nil?
      db = File.expand_path(db_file,"#{File.dirname(__FILE__)}/../")
      unless File.exist? db then
        @log.error("SQLite db file '#{db}' is not exist")
        return 
      end

      begin 
        @connect = SQLite3::Database.new(db)
        @log.info("SQLite '#{db}' is connected")
      rescue => ex
        @connect = nil 
        @log.error("Open SQLite3 file #{db} Error:#{ex}")
      end  
    else
      oracle_connnect_conf = @config['connect'][@connect_name]
      if oracle_connnect_conf.nil? 
        @log.error("Oracle config '#{@connect_name}' is not exist")
        return 
      end

      require 'oci8'

      tns = %Q/(DESCRIPTION = 
                   (ADDRESS_LIST = 
                               (ADDRESS = (PROTOCOL = TCP) 
                                          (HOST = #{oracle_connnect_conf['host']})
                                          (PORT = #{oracle_connnect_conf['port']}))) 
                   (CONNECT_DATA = (SID = #{oracle_connnect_conf['sid']})))/
      
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

