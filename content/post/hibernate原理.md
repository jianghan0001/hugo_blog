+++
tags = ["hibernate"]
title = "hibernate原理"
draft = false
date = "2017-01-13T12:54:24+02:00"

+++


##### hibernate 简介：  

hibernate是一个开源框架，它是对象关联关系映射的框架，它对JDBC做了轻量级的封装，而我们java程序员可以使用面向对象的思想来操纵数据库。


hibernate核心接口  
 
session：负责被持久化对象CRUD操作  

sessionFactory:负责初始化hibernate，创建session对象  

configuration:负责配置并启动hibernate，创建SessionFactory  

Transaction:负责事物相关的操作  

Query和Criteria接口：负责执行各种数据库查询




##### hibernate工作原理：

1.通过Configuration config = new Configuration().configure();//读取并解析hibernate.cfg.xml配置文件

2.由hibernate.cfg.xml中的<mapping resource="com/xx/User.hbm.xml"/>读取并解析映射信息

3.通过SessionFactory sf = config.buildSessionFactory();//创建SessionFactory

4.Session session = sf.openSession();//打开Sesssion

5.Transaction tx = session.beginTransaction();//创建并启动事务Transation

6.persistent operate操作数据，持久化操作

7.tx.commit();//提交事务

8.关闭Session

9.关闭SesstionFactory


##### 为什么要用hibernate：


总结：轻量级的ORM框架，对jdbc访问数据库做了封装，支持多种关系数据库与对象间的映射，大大简化了dao层的编码工作。


1. 对JDBC访问数据库的代码做了封装，大大简化了数据访问层繁琐的重复性代码。


2. Hibernate是一个基于JDBC的主流持久化框架，是一个优秀的ORM实现。他很大程度的简化DAO层的编码工作



3. hibernate使用Java反射机制，而不是字节码增强程序来实现透明性。


4. hibernate的性能非常好，因为它是个轻量级框架。映射的灵活性很出色。它支持各种关系数据库，从一对一到多对多的各种复杂关系。



##### get和load的根本区别

一句话，hibernate对于 load方法认为该数据在数据库中一定存在，可以放心的使用代理来延迟加载，如果在使用过程中发现了问题，只能抛异常；而对于get方 法，hibernate一定要获取到真实的数据，否则返回null


##### Hibernate缓存

Hibernate是一个持久层框架，经常访问物理数据库，为了降低应用程序对物理数据源访问的频次，从而提高应用程序的运行性能。缓存内的数据是对物理数据源中的数据的复制，应用程序在运行时从缓存读写数据，在特定的时刻或事件会同步缓存和物理数据源的数据

Hibernate缓存分类：

  Hibernate缓存包括两大类：Hibernate一级缓存和Hibernate二级缓存

Hibernate一级缓存又称为“Session的缓存”，它是内置的，意思就是说，只要你使用hibernate就必须使用session缓存。由于Session对象的生命周期通常对应一个数据库事务或者一个应用事务，因此它的缓存是事务范围的缓存。

在第一级缓存中，持久化类的每个实例都具有唯一的OID。 
Hibernate二级缓存又称为“SessionFactory的缓存”，由于SessionFactory对象的生命周期和应用程序的整个过程对应，因此Hibernate二级缓存是进程范围或者集群范围的缓存，有可能出现并发问题，因此需要采用适当的并发访问策略，该策略为被缓存的数据提供了事务隔离级别。第二级缓存是可选的，是一个可配置的插件，在默认情况下，SessionFactory不会启用这个插件。


##### 什么样的数据适合存放到第二级缓存中？ 
　　
1 很少被修改的数据 　　  

2 不是很重要的数据，允许出现偶尔并发的数据 　　


3 不会被并发访问的数据 　　

4 常量数据 　　

不适合存放到第二级缓存的数据？ 　　

1经常被修改的数据 　　

2 .绝对不允许出现并发访问的数据，如财务数据，绝对不允许出现并发 
　　
3 与其他应用共享的数据。 



##### Hibernate查找对象如何应用缓存？

当Hibernate根据ID访问数据对象的时候，首先从Session一级缓存中查；查不到，如果配置了二级缓存，那么从二级缓存中查；如果都查不到，再查询数据库，把结果按照ID放入到缓存

删除、更新、增加数据的时候，同时更新缓存




##### 什么是延迟加载？

延迟加载机制是为了避免一些无谓的性能开销而提出来的，所谓延迟加载就是当在真正需要数据的时候，才真正执行数据加载操作。在Hibernate中提供了对实体对象的延迟加载以及对集合的延迟加载，另外在Hibernate3中还提供了对属性的延迟加载。


##### Hibernate的查询方式有哪些？

本地SQL查询、Criteria、Hql


##### 如何优化Hibernate？

1.使用双向一对多关联，不使用单向一对多

2.灵活使用单向一对多关联

3.不用一对一，用多对一取代

4.配置对象缓存，不使用集合缓存

5.一对多集合使用Bag,多对多集合使用Set

6. 继承类使用显式多态


7. 表字段要少，表关联不要怕多，有二级缓存撑腰 



##### Hibernate中怎样处理事务

Hibernate是对JDBC的轻量级对象封装，Hibernate本身是不具备Transaction 处理功能的，Hibernate的Transaction实际上是底层的JDBC Transaction的封装，或者是JTA Transaction