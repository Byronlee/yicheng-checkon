

# job_type :task, 'ruby /home/simlegate/workspace/yicheng-checkon/util/task.rb'
# every 1.minute  do
#    task  "/home/simlegate/workspace/yicheng-checkon/util/task.rb"
# end


job_type :runner, 'cd /home/simlegate/workspace/yicheng-checkon && rails runner -e :environment ":task"'



every :day, :at => '2:00am' do
    runner " StaffRecord.staff_everyday_records", :environment => :development 
    runner " StaffRecord.staff_everyday_records", :environment => :production 
    runner " TraineeRecord.trainee_everyday_records", :environment => :development 
    runner " TraineeRecord.trainee_everyday_records", :environment => :production 
end


every :day, :at => '11:00pm' do
    runner " StaffRecord.auto_submit", :environment => :development 
    runner " StaffRecord.auto_submit", :environment => :production 
    runner " TraineeRecord.auto_submit", :environment => :development 
    runner " TraineeRecord.auto_submit", :environment => :production 
end




# every 1.minute  do
#   runner "Record.whenever_add", :environment => :development 
# end
