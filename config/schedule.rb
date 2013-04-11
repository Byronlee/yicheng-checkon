

# job_type :task, 'ruby /home/simlegate/workspace/yicheng-checkon/util/task.rb'
# every 1.minute  do
#    task  "/home/simlegate/workspace/yicheng-checkon/util/task.rb"
# end


job_type :runner, 'cd /home/simlegate/workspace/yicheng-checkon && rails runner -e :environment ":task"'



every :day, :at => '2:00am' do
    runner "Crontask.produce_everyday_records", :environment => :development 
    runner "Crontask.produce_everyday_records", :environment => :production 
end


every :day, :at => '11:00pm' do
  runner " Crontask.submit_everyday_records", :environment => :development
  runner " Crontask.submit_everyday_records", :environment => :production 
end




# every 1.minute  do
#   runner "Record.whenever_add", :environment => :development 
# end
