namespace :log do  
  desc "Truncates all *.log files in log/ to zero bytes"  
  task :clear_all do  
    FileList["#{RAILS_ROOT}/log/*.out"].each do |log_file|  
      f = File.open(log_file, "w")  
      f.close  
    end  
    FileList["#{RAILS_ROOT}/log/*.err"].each do |log_file|  
      f = File.open(log_file, "w")  
      f.close  
    end  
    FileList["#{RAILS_ROOT}/log/*.log"].each do |log_file|  
      f = File.open(log_file, "w")  
      f.close  
    end  
  end  
end  
