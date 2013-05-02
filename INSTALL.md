## 伊诚考勤系统
  该系统能为伊诚公司所有员工进行每日考勤以及统计考勤数据

## 环境要求：

* mongodb & mongoid 3.x
* linux 
* ruby 1.9.3 & rails 3.2.13

## 安装
克隆代码到本地：

       git clone https://github.com/zhiyisoft/yicheng-checkon.git
进入项目根目录：

       cd yicheng-checkon
       
安装依赖包：

       bundle install
       
初始化数据库：

       # 初始化考勤项
       rails r db/test.rb [-e production] (默认development)
       # 在开发环境中初始化考勤数据
       rails runner -e development "Crontask.produce_everyday_records"
       # 在产品环境中初始化考勤数据
       rails runner -e production "Crontask.produce_everyday_records"
       # 详情请看path/to/config/schedule.rb
运行项目：

       rails s
模拟用户：

        # 用户名和密码相同
       人事部： yaye  ,  文员： cangnan
       
## 定时任务
写入定时任务：

        whenever -iw  #=> [write] crontab file updated
        
查看定时任务：

        crontab -l
        # 提示信息
        # Begin Whenever generated tasks for: w
        * * * /bin/bash -l -c 'cd your rails root path && rails runner -e production '\''Crontask.produce_everyday_records'\'''
  
        * * * /bin/bash -l -c 'cd your rails root path && rails runner -e production '\'' Crontask.submit_everyday_records'\'''

        # End Whenever generated tasks for: w
