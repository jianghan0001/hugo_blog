+++
tags = ["java"]
title = "char存储汉字"
draft = false
date = "2017-02-16T10:54:24+02:00"

+++



请教一个面试中遇到的SQL语句的查询问题
表中有A B C三列,用SQL语句实现：当A列大于B列时选择A列否则选择B列，当B列大于C列时选择B列否则选择C列。

	
	select (case when a>b then a else b end ),
	(case when b>c then b esle c end)
	from table_name


S(S#,SN,SD,SA)S#,SN,SD,SA分别代表学号，学员姓名，所属单位，学员年龄

C(C#,CN)C#,CN分别代表课程编号，课程名称

SC(S#,C#,G) S#,C#,G分别代表学号，所选的课程编号，学习成绩

（1）使用标准SQL嵌套语句查询选修课程名称为’税收基础’的学员学号和姓名?
	
	答案：select s# ,sn from s where S# in(select S# from c,sc where c.c#=sc.c# and cn=’税收基础’)

(2) 使用标准SQL嵌套语句查询选修课程编号为’C2’的学员姓名和所属单位?

	答：select sn,sd from s,sc where s.s#=sc.s# and sc.c#=’c2’

(3) 使用标准SQL嵌套语句查询不选修课程编号为’C5’的学员姓名和所属单位?
	
	答：select sn,sd from s where s# not in(select s# from sc where c#=’c5’)

(4)查询选修了课程的学员人数
	
	答：select 学员人数=count(distinct s#) from sc

(5) 查询选修课程超过5门的学员学号和所属单位?
	
	答：select sn,sd from s where s# in(select s# from sc group by s# having count(distinct c#)>5)

目前在职场中很难找到非常合格的数据库开发人员。有人说:“SQL开发是一门语言，它很容易学，但是很难掌握。”

在面试过程中多次碰到两道SQL查询的题目，一是查询A(ID,Name)表中第31至40条记录，ID作为主键可能是不是连续增长的列，完整的查询语句如下：
	
	select top 10 * from A where ID >(select max(ID) from (select top 30 ID from A order by A ) T) order by A

另外一道题目的要求是查询表A中存在ID重复三次以上的记录,完整的查询语句如下：
	
	select * from(select count(ID) as count from table group by ID)T where T.count>3

以上两道题目非常有代表意义，望各位把自己碰到的有代表的查询都贴上来。

	create table testtable1
	
	(
	
	id int IDENTITY,
	
	department varchar(12)
	
	)
	
	select * from testtable1
	
	insert into testtable1 values('设计')
	
	insert into testtable1 values('市场')
	
	insert into testtable1 values('售后')
	
	/*

结果

id department

1   设计

2   市场

3   售后

	

	create table testtable2
	
	(
	
	id int IDENTITY,
	
	dptID int,
	
	name varchar(12)
	
	)
	
	insert into testtable2 values(1,'张三')
	
	insert into testtable2 values(1,'李四')
	
	insert into testtable2 values(2,'王五')
	
	insert into testtable2 values(3,'彭六')
	
	insert into testtable2 values(4,'陈七')
	
	/*

用一条SQL语句，怎么显示如下结果

id dptID department name

1   1      设计        张三

2   1      设计        李四

3   2      市场        王五

4   3      售后        彭六

5   4      黑人        陈七

*/

答案是：

	SELECT testtable2.* , ISNULL(department,'黑人')
	
	FROM testtable1 right join testtable2 on testtable2.dptID = testtable1.ID