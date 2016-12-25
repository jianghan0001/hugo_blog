
+++
date = "2014-07-11T10:54:24+02:00"
draft = false
title = "mysql获取各个数据库表及字段信息"
tags = [

"sql"

]
+++




MySQL安装成功后可以看到已经存在mysql、information_schema和test这个几个数据库，information_schema库中有一个名为COLUMNS的表，    



information_schema数据库是MySQL自带的，它提供了访问数据库元数据的方式。什么是元数据呢？元数据是关于数据的数据，如数据库名或表名，列的数据类型，或访问权限等。有些时候用于表述该信息的其他术语包括“数据词典”和“系统目录”。
在 MySQL中，把 information_schema 看作是一个数据库，确切说是信息数据库。其中保存着关于MySQL服务器所维护的所有其他数据库的信息。如数据库名，数据库的表，表栏的数据类型与访问权限等。




这个表中记录了数据库中所有所有数据库及表的信息。知道这个表后，获取任意表的字段就只需要一条select语句即可。例如：

select COLUMN_NAME from information_schema.COLUMNS where table_name = ‘your_table_name’;

上述的做法有一点问题，如果多个数据库中存在你想要查询的表名，那么查询的结果会包括全部的字段信息。通过DESC information_schema.COLUMNS可以看到该表中列名为TABLE_SCHEMA是记录数据库名，因此下面的写法更为严格

select COLUMN_NAME from information_schema.COLUMNS where table_name = 'your_table_name' and table_schema = 'your_db_name'










