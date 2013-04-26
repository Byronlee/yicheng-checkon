require 'mongo'

require "#{File.dirname(__FILE__)}/utils"

class MongoCache
  include Mongo

  def initialize(mongo_config)
    @db = MongoClient.new(mongo_config["server"], mongo_config["port"]).db(mongo_config["db"])
  end

  def connected?
    not @db.nil?
  end
  
  def method_missing(method_name, *args, &block)
    if method_name.to_s =~ /^collection_(\w+)$/
      return @db.collection($1)
    else
      super
    end
  end

end
