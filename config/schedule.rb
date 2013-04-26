
job_type :runner, "cd #{Whenever.path} && rails runner -e :environment ':task'"

every :day, :at => '2:00am' do
  runner "Crontask.produce_everyday_records", :environment => :development 
  runner "Crontask.produce_everyday_records", :environment => :production 
end

every :day, :at => '11:00pm' do
  runner " Crontask.submit_everyday_records", :environment => :development
  runner " Crontask.submit_everyday_records", :environment => :production 
end
