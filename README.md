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
       rails r db/test.rb
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
        
h1. 项目背景及意义

h2. 背景

伊诚公司一直以来采用通达OA作为工作平台，但是随着员工人数增加和应用模块增多，使用情况却越来越差，表现为速度慢、功能不全、人工参与多。
经过IT咨询人员分析，为架构不合理和开发能力不足双重引发，为改进此现象，决定采用SOA模式，将原来部署在通达OA中的各个模块进行独立迁出。

前期已经迁出工作总结，但耗时过长，由于内部开发人力不足，现决定同时引入外部力量迁出其他模块。考勤系统为此外包模式引入的第一个模块。

h2. 愿景

能够建立快速开发模式，为后续模块迁出作一个重要参照
将人力资源月底出勤考核统计时间由6-10天降为1天

h2. 业务关注点

* 考勤登记员能做对他所管辖区域的所有人进行考勤登记
* 考勤登记员能够对一些错误或者需要修改的考勤发起申请修改流程
* 人事部门能够对相关员工发起的流程进行审批
* 能够方便准确的查询员工的出勤信息 
* *人事部门能获取每个员工的准确的考勤数据*
* *能自动汇总公司某些业务流程上需要的统计数据或报表*
* *公司领导能获取准确的员工出勤情况的统计信息*
* *能和公司其他业务系统协作，自动化的完成某些业务流程，如病假审核*
* 提高参与系统的各部门的工作效率
* 让系统导致考勤出错率降低
* 提高系统性能

针对以上目标的功能分解，可查阅"用例分析"

h1. 项目干系人

h2. 伊诚公司 

* 领导：党杰【景琦】
* 项目负责人：王建斌【杰弗】13880030935
* 信息部：罗浩 13880446756
* 人力资源部：【豌豆】18227650895
* 劳动检察：【无双】13540449915

h2. 成都知一软件有限公司  
  
* 苏渝：18602881279

h2. 成都大学开发团队

* 何源：13320963363
* 张强： 18782943147
* 李江华：13880156590  

h1. 项目现状

h3. 关联基础设施现状

一台可部署的服务器

h3. 关联应用系统现状

* 已有一个正在使用的考勤系统，可完成基本的考勤和统计和查询
* 能够提供现在新系统的数据库的帐号
* 和区域文员交流一次，和人事部门督查部门交流一次
* 新系统已做了一个基本原型

h1. 假定和约束

* 预计经费：暂无
* 开发周期：时间很急，一周后提交可使用的原型
* 运行环境：Linux
* 编程语言：Ruby, Ruby on Rails, MongoDB

h1. 风险分析

目前无合同无费用，但是可能由于分析不当，没有按时完成任务可能造成白干，如果做的也可能为后续二期项目打下基础。
所以必须合理控制开发周期，缩短迭代时间，实现真正敏捷
