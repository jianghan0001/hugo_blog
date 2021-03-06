+++
tags = ["hibernate"]
title = "hibernate的N+1问题"
draft = false
date = "2017-02-13T10:58:24+02:00"

+++




一般而言说n+1意思是，无论在一对多还是多对一当查询出n条数据之后，每条数据会关联的查询1次他的关联对象，这就叫做n+1。

　　但是我的理解是，本来所有信息可以一次性查询出来，也就是简单的连表查询，但是Hibernate会首先查询1次得到当前对象，然后当前对象里面的n个关联对象会再次访问数据库n次，这就是1+n问题。

　　他们二者之间表达的意思其实是一样的，只是描述这个问题的角度不同。不过我认为1+n更准确，因为以前我第一次看到n+1问题的时候就总是在想是不是查n然后多出一次，那其实是没什么影响的，后来才明白。

　　既然出现这个问题，肯定是要避免的，尤其是对于高并发的互联网应用，这种现象是绝对不允许出现的。

　　Hibernate给出了3中解决方案，不过我个人比较偏向于手动写sql，也就是JDBC或者iBatis那种风格。因为这样的sql是绝对可控的，只是在移植性方面不如Hibernate。各有所长各有所短吧。

　　下面是3中解决方案：

　　1.延迟加载，当需要的时候才查询，不需要就不查询，但是感觉这种方式治标不治本，尤其是在那种报表统计查询的时候更为明显。

　　2.fetch="join"，默认是fetch="select"，这个其实说白了就是一个做外连接，允许外键为空的情况之下。

　　3.二级缓存，第一次查询之后存在内存中，后面的相同查询就快了。但是有2个缺点：a.二级缓存首先是有点浪费内存空间，如果多了的话浪费还比较严重，这是一个不好的方面，当然这不是主要的，主要的问题在于，二级缓存的特性决定的，那就是很少的增删改才做二级缓存，而对于普通的CRUD系统，其实不太适合。所以感觉也不是首选。

　　综合来看，用外联结的方式比较好，Hibernate里面貌似叫什么迫切外联结，不知道他究竟有多迫切，非得取个这样的名字，不就是个关联查询嘛。