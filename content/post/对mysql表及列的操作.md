
+++
tags = ["java","sql","数据库"]
title = "对mysql表及列的操作"
draft = false
date = "2017-03-01T10:54:24+02:00"

+++




	查看列：desc 表名;
	修改表名：alter table t_book rename to bbb;
	添加列：alter table 表名 add column 列名 varchar(30);
	删除列：alter table 表名 drop column 列名;
	修改列名MySQL： alter table bbb change nnnnn hh int;
	修改列名SQLServer：exec sp_rename't_student.name','nn','column';
	修改列名Oracle：lter table bbb rename column nnnnn to hh int;
	修改列属性：alter table t_book modify name varchar(22);