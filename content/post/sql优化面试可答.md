+++
tags = ["sql","数据库","面试"]
title = "sql优化面试可答"
draft = false
date = "2017-02-15T10:54:24+02:00"

+++


尽量避免全表扫描，首先应考虑在 where 及 order by 涉及的列上建立索引。

尽量避免在 where 子句中对字段进行 null 值判断

尽量避免在 where 子句中使用!=或<>操作符

尽量避免在 where 子句中使用or 来连接条件


in 和 not in 也要慎用，否则会导致全表扫描

下面的查询也将导致全表扫描：select id from t where name like '李%'若要提高效率，可以考虑全文检索。

尽量避免在 where 子句中对字段进行表达式操作

尽量避免在where子句中对字段进行函数操作

多时候用 exists 代替 in 是一个好的选择

尽量使用数字型字段

任何地方都不要使用 select * from t 


索引并不是越多越好，索引固然可 以提高相应的 select 的效率，但同时也降低了 insert 及 update 的效率，因为 insert 或 update 时有可能会重建索引，所以怎样建索引需要慎重考虑，视具体情况而定。


