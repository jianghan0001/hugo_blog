
+++
tags = ["sql"]
title = "sql基础"
draft = false
date = "2017-02-16T10:54:24+02:00"

+++



sql定义：sql是用语访问和处理数据库的标准的计算机语言

什么是sql：

sql指结构化查询语言  
sql使我们有能力访问数据库  
sql是一种ansi的标准计算机语言（ansi，美国国家标准化组织）  
sql能做什么？  
面向数据库执行查询  
可从数据库取回数据  
可在数据库中插入新的记录  
可更新数据库中的数据
可从数据库删除记录  
可创建新数据库  
可在数据库中创建新表  
可在数据库中创建存储过程  
可在数据库中创建视图  
可以设置表、存储过程和视图的权限  

sql是一种标准，是一门暗示的标准计算机语言，用来访问和操作数据库系统，可与数据库系统协同工作，但不幸的是，存在很多不同版本的sql语言，而为了与暗示标准相兼容，它们必须以相似的方式来共同支持一些主要的关键词  

要创建发布数据库中数据的网站，需要以下要素：rdbms数据库程序，服务器端脚本语言，sql，html/css

（rdbms：指的是关系型数据库管理系统，是ql的基础，是所有现代数据库系统的基础，rdbms中的数据存储在被称为表table的数据库对象中，表是相关数据项的集合，由列和行组成）
语法：

数据库表包含一个或多个表，每个表有一个名字标识，表包含数据记录，表的名称与标识名无关

sol语句	

	select lastname from persons 

sql对大小写不敏感

分号：有些数据库要求在每段语句末端使用分号，目的是分隔每条语句，这样就可以在对服务器的相同请求执行一条以上的语句

sql dml和ddl

sql可以分为两个部分：数据操作语言dml和数据定义语言ddl

sql（结构化查询语言）作用：是用于执行查询的语法，也用于更新、插入、删除记录

查询和更新构成dml

	select-从数据库表中获取数据
	
	updata-更新数据库表中的数据
	
	delete-从数据库表中删除数据
	
	insert into-向数据库插入数据

ddl让我们有能力创建或删除表格，我们可以定义索引（键），规定表之间的链接，以及施加表之间的约束

	create database-创建新数据库

	alter database-修改数据库  
	create table-创建新表  
	alter table-变更（改变）数据库表   
	drop table-删除表  
	create index-创建索引（搜索键）  
	drop index-删除索引  

关键词select和select*

sql select语句用于从表中选取数据，结果存储在一个结果表中（称为结果集）表和数据表是两个不同的表，区分开
sql select语法

select列名称from表名称，以及select from表名称

	select lastname，firstname from personss
结果是调出相应列的数据列

	select*from persons

结果是调出所有列的快捷方式

注意select调出的是相对应的列，而select*调出的是所以列的快捷方式
在结果集（select-set）中导航

由于sql查询程序获得的结果存在一个结果集中，大多数数据库软件系统都允许使用变成函数在结果集中导航，比如Move-To-First-Record、Get-Record-Content、Move-To-Next-Record 等等。

类似这些编程函数不在sql的教程范围之内，如果要学习，应该学习add教程和朴韩屏教程

关键词select distinct（不同）意味查找不同的值
在表中，可能包含重复的值，有时仅仅希望看到不同的值，那么这时候，select distinct就派上用场了

关键词distinct用于返回唯一不同的值
语法：select distinct列名称from表名称
使用distinct关键词：

	select company from orders假设结果出现重复值，那么
	select distinct company from orders，

这样结果集中重复的数据只有有一次

关键词where，where子句

语法：select列名称from表名称where列 +运算符+ 值
=,(不等于在某些版本的sql中，可以写成！=)，,>=,比如，只希望选取居住在城市“beijing”中的人，需要在select语句中添加where子句

	select*from persons where city='beijing'

注意引号的使用：大部分数据库系统也接受双引号，sql使用单引号来环绕文本值，如果是数值不能用引号

比如：  

	select*from persons where firstname='bush'
	select*from persons where year>1965

关键词and和or，依旧是运用在子语句中
and和or可在where子语句中把两个或多个条件结合起来
如果第一和第二条件都成立，则and运算符显示一条记录，（否则应该没有)
如果第一和第二条件只有一个成立，则or运算符显示一条记录（如果两个都成立或者没有成立的应该不显示，这应该定义是错误的）

实例

	select*from persons where firstname='thomas' and lastname='carter'  
	
	select*from persons wherefirstname='thomas' or lastname'carter'

结合and和or

	select*from persons where (firstname='thomas' or firstname='william') 
	and lastname='carter'

关键词order(此处不可忽略desc)用语对结果集进行排序
order by 语句用语根据制定的列对结果集进行排序，并且是升序，而desc是降序
	
	select company,ordernumber from orders order by company
	select company,ordernumber from orders order by company,ordernumber
	
	select company,ordernumber from orders order by company desc
	select company,ordernumber from orders order by company desc ,ordernumber asc

注意：在以上的结果中有两个相等的公司名称 (W3School)。只有这一次，在第一列中有相同的值时，第二列是以升序排列的。如果第一列中有些值为 nulls 时，情况也是这样的。 

关键词insert into,insert into语句用于向表格中插入新的行
语法：

	insert into表名称values（值1，值2...）
	insert into table_name（列1，列2...）values（值1，值2，...）
比如：

	insert into persons values('gates','bill','xuanwumen10','beijing')
	insert into persons(lastname,address)values('wilson','champs-elysees')
关键词update，update语句用语修改表中的数据
语法：update 表名称 set 列名称=新植where列名称=某值
更新某一行的某一列：

	update person set firstname='fred'where lastname='wilson'
	更新某一行的若干列：
	update persons set address ='zhongshan23',city='nanjing'
	where lastname='wilson'
关键词delete，delete语句用语删除表中的行
语法：delete from表名称where 列名称=值
删除某一行：

	delete from persons where lastname='wilson'

删除所有行，可以在不删除表的情况下删除所有行，这意味这表的结构、属性和索引都是完整的  

	delete from table_name
	delete*from table_name