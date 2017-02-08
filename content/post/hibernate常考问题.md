+++
tags = ["hibernate,面试题"]
title = "hibernate常考问题"
draft = false
date = "2017-02-08T10:58:24+02:00"

+++



##### Hibernate框架中的核心接口有哪些

5个核心接口:

Configuration 接口：配置 hibernate，根据其启动 hibernate，创建
SessionFactory 对象；

SessionFactory 接口：初始化 Hibernate，充当数据存储源的代理，创建session 对象，sessionFactory 是线程安全的，意味着它的同一个实例可以被应用的多个线程共享，是重量级、二级缓存；

Session 接口：负责保存、更新、删除、加载和查询对象，是线程不安全的 ，避免多个线程共享同一个 session，是轻量级、一级缓存；

Transaction 接口：管理事务；

Query 和 Criteria 接口：执行数据库的查询。



##### Hibernate.cfg.xml配置文件中，应该包含哪些具体的配置内容



	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE hibernate-configuration PUBLIC
	          "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
	          "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
	<hibernate-configuration>
	
	<session-factory>
	    <property name="connection.url">jdbc:oracle:thin:@127.0.0.1:1521:orcl</property>
	    <property name="connection.username">username</property>
	    <property name="connection.password">password</property>
	    <!-- 数据库JDBC驱动类名 -->
	    <property name="connection.driver_class">oracle.jdbc.driver.OracleDriver</property>
	    <!-- 数据库方言 -->
	    <property name="dialect">org.hibernate.dialect.Oracle10gDialect</property>
	    <!-- ddl语句自动建表 -->
	    <property name="hbm2ddl.auto">none</property>
	    <property name="show_sql">true</property>
	    <property name="format_sql">true</property>
	    
	    <!-- 连接池配置 -->
	    <property name="hibernate.connection.provider_class">
	        org.hibernate.service.jdbc.connections.internal.C3P0ConnectionProvider
	    </property>
	    <!-- 连接池中JDBC连接的最小数量。Hibernate默认为1 -->
	    <property name="hibernate.c3p0.min_size">5</property>
	    <!-- 连接池中JDBC连接的最大数量。Hibernate默认为100 -->
	    <property name="hibernate.c3p0.max_size">20</property>
	    <!-- 何时从连接池中移除一个空闲的连接（以秒为单位）时。Hibernate默认为0，永不过期 -->
	    <property name="hibernate.c3p0.timeout">300</property>
	    <!-- 被缓存的预编译语句数量。用来提高性能。Hibernate默认为0，缓存不可用-->
	    <property name="hibernate.c3p0.max_statements">100</property>
	    <!-- 一个连接被自动验证前的闲置时间（以秒为单位）。Hibernate默认为0 -->
	    <property name="hibernate.c3p0.idle_test_period">3000</property>
	    
	    <!-- 注册ORM映射文件 -->
	    <mapping class="com....." />
	    
	</session-factory>
	</hibernate-configuration>



##### Hibernate中Load和Get两种方法查询数据的区别

load是采用延迟机制(load语句不读库，等使用非主键时才去读库)，而get不采用延迟机制(get语句时马上读库)。

a.当数据库不存在对应ID数据时，调用load()方法将会抛出ObjectNotFoundException异常，get()方法将返回null.

b．当对象.hbm.xml配置文件<class>元素的lazy属性设置为true时，调用load()方法时则返回持久对象的代理类实例，此时的代理类实例是由运行时动态生成的类，该代理类实例包括原目标对象的所有属性和方法，该代理类实例的属性除了ID不为null外，所在属性为null值，查看日志并没有Hibernate?SQL输出，说明没有执行查询操作，当代理类实例通过getXXX()方法获取属性值时，Hiberante才真正执行数据库查询操作。当对象.hbm.xml配置文件<class>元素的lazy属性设置为false时，调用load()方法则是立即执行数据库并直接返回实体类，并不返回代理类。而调用get()方法时不管lazy为何值，都直接返回实体类。


c．load()和get()都会先从Session缓存中查找，如果没有找到对应的对象，则查询Hibernate二级缓存，再找不到该对象，则发送一条SQL语句查询。


总之对于get和load的根本区别，一句话，hibernate对于load方法认为该数据在数据库中一定存在，可以放心的使用代理来延迟加载，如果在使用过程中发现了问题，只能抛异常；而对于get方法，hibernate一定要获取到真实的数据，否则返回null。




.Hibernate.cfg.xml配置文件中，应该包含哪些具体的配置内容?
Hibernate运行的底层信息：数据库的URL、用户名、密码、JDBC驱动类，数据库Dialect, 连接池等。
Hibernate映射文件（*.hbm.xml）。

##### 简述Hibernate的主键机制
A, 数据库提供的主键生成机制。identity、sequence（序列）。
B, 外部程序提供的主键生成机制。increment （递增） ，hilo（高低位） ，seqhilo（使用序列的高低位 ），uuid.hex(使用了IP地址+JVM的启动时间（精确到1/4秒）+系统时间+一个计数器值（在JVM中唯一） )，uuid.string。
C, 其它。native（本地），assigned（手工指定），foreign（外部引用）

##### 请简述Hibernate中cascade,inverse，constrained几个属性的区别?

cascade（级联） :

是操作主表或者从表时，要不要自动操作从表或者主表，比如，保存主表的时候，要不要也默认保存从表,cascade 的值主要有四种：none,all,delete,save-update。

Inverse:

是指要不要交出控制权,值有true(交出控制权，不再维护双方的关系)和false(不交出控制权，继续维护双方的关系)。

constrained：

表示当前引用对象的主键是否作为当前对象的主键参考,true为是，false为否.


##### Hibernate中的延迟机制的原理，以及Hibernate中数据有几种延迟加载方式?

延迟加载机制是为了避免一些无谓的性能开销而提出来的，所谓延迟加载就是当在真正需要数据的时候，才真正执行数据加载操作。

Hibernate中提供了三种延迟加载方式分别是

A． 实体对象的延迟加载
B． 集合的延迟加载
C． 属性的延迟加载




##### 说说 Hibernate 的缓存

Hibernate缓存包括两大类：Hibernate一级缓存和Hibernate二级缓存：
1）. Hibernate一级缓存又称为”Session的缓存”，它是内置的，不能被卸载。由于Session对象的生命周期通常对应一个数据库事务或者一个应用事务，因此它的缓存是事务范围的缓存。在第一级缓存中，持久化类的每个实例都具有唯一的OID。
2）.Hibernate二级缓存又称为”SessionFactory的缓存”，由于SessionFactory对象的生命周期和应用程序的整个过程对应，因此Hibernate二级缓存是进程范围或者集群范围的缓存，有可能出现并发问题，因此需要采用适当的并发访问策略，该策略为被缓存的数据提供了事务隔离级别。第二级缓存是可选的，是一个可配置的插件，在默认情况下，SessionFactory不会启用这个插件。
当Hibernate根据ID访问数据对象的时候，首先从Session一级缓存中查；查不到，如果配置了二级缓存，那么从二级缓存中查；如果都查不到，再查询数据库，把结果按照ID放入到缓存。删除、更新、增加数据的时候，同时更新缓存。

