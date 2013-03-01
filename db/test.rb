# encoding: utf-8
["全勤","公出","培训","事假","病假","产假","休息","调休","矿工","迟到"].each do |behave|
  Behave.create(name: behave,proper: false)
end 
[:上午,:下午].each do |unit|
  CheckUnit.create(name: unit,ratio: 50)
end
