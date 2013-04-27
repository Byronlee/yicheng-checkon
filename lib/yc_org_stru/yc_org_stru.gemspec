# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|  
  s.name        = 'yc_org_stru'  
  s.version     = '1.0.0'  
  s.date        = '2013-04-26'  
  s.summary     = "yc organization"  
  s.description = ""  
  s.authors     = ["zhiyi soft"]  
  s.email       = 'heyuan@zhiyisoft.com'  
  s.files         = ["lib/org_stru.rb"]
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/zhiyisoft/yicheng-checkon'  

  s.add_dependency 'json'
  s.add_dependency 'rubytree'
  s.add_dependency 'sqlite3'
  s.add_dependency 'mongo'
  s.add_dependency 'bson_ext'
 
end  
