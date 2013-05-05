# encoding: utf-8

["请假","旷工","迟到","调休","离职","上班"].each do |type|
  BehaveType.create(name: type)
end

[:上午,:下午].each do |unit|
  CheckUnit.create(name: unit,ratio: 50)
end

Settings.notice_types.each do |type|
  NoticeType.create(name: type)
end
