# encoding: utf-8

["上班","请假","缺席","迟到","调休","离职"].each do |type|
  BehaveType.create(name: type)
end

[:上午,:下午].each do |unit|
  CheckUnit.create(name: unit,ratio: 50)
end
