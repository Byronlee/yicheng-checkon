# encoding: utf-8
["全勤","公出","培训","事假","病假","产假","休息","调休","矿工","迟到","离职"].each do |behave|
  if behave == "全勤"
    Behave.create(name: behave,proper: false,default: true)
  else
    Behave.create(name: behave,proper: false)
  end
end 
[:上午,:下午].each do |unit|
  CheckUnit.create(name: unit,ratio: 50)
end
