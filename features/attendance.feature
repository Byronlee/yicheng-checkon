# language: zh-CN
# -*- coding: utf-8 -*-

功能:作为一个考勤系统，能够正常的录入每天所有员工的考勤数据，能够对不正常的数据进行修改，以及对所需数据的查询，能对每月数据的汇总

场景大纲: 系统登录
   假如　我打开网址<http://proj.cdu.edu.cn>
   那么　我应该看到<>
   当　我以<username>登录
   并且　填写登录密码<password>
   那么　我应该看到<result>

例子:
   | username          | password          | result         |
   | 12345             | 12345             | 人事部          |
