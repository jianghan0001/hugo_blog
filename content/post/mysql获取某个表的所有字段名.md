
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


//根据数据库名和表明取所有的字段名

select COLUMN_NAME from information_schema.COLUMNS where table_name = 'your_table_name' and table_schema = 'your_db_name'







## information_scheme表

提供了当前mysql实例中所有数据库的信息。是show databases的结果取之此表。

TABLES表：提供了关于数据库中的表的信息（包括视图）。详细表述了某个表属于哪个schema，表类型，表引擎，创建时间等信息。是show tables from schemaname的结果取之此表。

COLUMNS表：提供了表中的列信息。详细表述了某张表的所有列以及每个列的信息。是show columns from schemaname.tablename的结果取之此表。

STATISTICS表：提供了关于表索引的信息。是show index from schemaname.tablename的结果取之此表。

USER_PRIVILEGES（用户权限）表：给出了关于全程权限的信息。该信息源自mysql.user授权表。是非标准表。

SCHEMA_PRIVILEGES（方案权限）表：给出了关于方案（数据库）权限的信息。该信息来自mysql.db授权表。是非标准表。

TABLE_PRIVILEGES（表权限）表：给出了关于表权限的信息。该信息源自mysql.tables_priv授权表。是非标准表。

COLUMN_PRIVILEGES（列权限）表：给出了关于列权限的信息。该信息源自mysql.columns_priv授权表。是非标准表。

CHARACTER_SETS（字符集）表：提供了mysql实例可用字符集的信息。是SHOW CHARACTER SET结果集取之此表。

COLLATIONS表：提供了关于各字符集的对照信息。

COLLATION_CHARACTER_SET_APPLICABILITY表：指明了可用于校对的字符集。这些列等效于SHOW COLLATION的前两个显示字段。

TABLE_CONSTRAINTS表：描述了存在约束的表。以及表的约束类型。

KEY_COLUMN_USAGE表：描述了具有约束的键列。

ROUTINES表：提供了关于存储子程序（存储程序和函数）的信息。此时，ROUTINES表不包含自定义函数（UDF）。名为“mysql.proc name”的列指明了对应于INFORMATION_SCHEMA.ROUTINES表的mysql.proc表列。

VIEWS表：给出了关于数据库中的视图的信息。需要有show views权限，否则无法查看视图信息。

TRIGGERS表：提供了关于触发程序的信息。必须有super权限才能查看该表。







