# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

job_type :runner, 'cd /home/simlegate/workspace/yicheng-checkon && rails runner -e :environment ":task"'



every 1.minute do
  command "echo 'one' && echo 'two'"
end

every 1.minute  do
  runner "Record.whenever_add", :environment => :development 
#  rake "my:rake:task"
#  command "/usr/bin/my_great_command"
end