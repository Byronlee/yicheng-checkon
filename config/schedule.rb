

# job_type :task, 'ruby /home/simlegate/workspace/yicheng-checkon/util/task.rb'
# every 1.minute  do
#    task  "/home/simlegate/workspace/yicheng-checkon/util/task.rb"
# end


job_type :runner, 'cd /home/simlegate/workspace/yicheng-checkon && rails runner -e :environment ":task"'



every :day, :at => '12:00pm' do
    runner " RecordsController.new.default_everyday_records", :environment => :development 
end


# every 1.minute  do
#   runner "Record.whenever_add", :environment => :development 
# end
