+++
tags = ["hibernate"]
title = "hibernate乐观锁悲观锁"
draft = false
date = "2017-02-19T10:54:24+02:00"

+++

悲观锁，正如其名，它指的是对数据被外界（包括本系统当前的其他事务，以及来自外部系统的事务处理）修改持保守态度，因此，在整个数据处理过程中，将数据处于锁定状态。悲观锁的实现，往往依靠数据库提供的锁机制（也只有数据库层提供的锁机制才能真正保证数据访问的排他性，否则，即使在本系统中实现了加锁机制，也无法保证外部系统不会修改数据）。

　　一个典型的依赖数据库的悲观锁调用：select * from account where name=”Erica” for update这条 sql 语句锁定了 account 表中所有符合检索条件（ name=”Erica” ）的记录。本次事务提交之前（事务提交时会释放事务过程中的锁），外界无法修改这些记录。悲观锁，也是基于数据库的锁机制实现。

在Hibernate使用悲观锁十分容易，但实际应用中悲观锁是很少被使用的，因为它大大限制了并发性：



图为Hibernate3.6的帮助文档Session文档的get方法截图，可以看到get方法第三个参数"lockMode"或"lockOptions"，注意在Hibernate3.6以上的版本中"LockMode"已经不建议使用。方法的第三个参数就是用来设置悲观锁的，使用第三个参数之后，我们每次发送的SQL语句都会加上"for update"用于告诉数据库锁定相关数据。

##### 使用乐观锁解决事务并发问题

　　相对悲观锁而言，乐观锁机制采取了更加宽松的加锁机制。悲观锁大多数情况下依靠数据库的锁机制实现，以保证操作最大程度的独占性。但随之而来的就是数据库性能的大量开销，特别是对长事务而言，这样的开销往往无法承受。乐观锁机制在一定程度上解决了这个问题。乐观锁，大多是基于数据版本（Version）记录机制实现。何谓数据版本？即为数据增加一个版本标识，在基于数据库表的版本解决方案中，一般是通过为数据库表增加一个"version"字段来实现。
　　乐观锁的工作原理：读取出数据时，将此版本号一同读出，之后更新时，对此版本号加一。此时，将提交数据的版本数据与数据库表对应记录的当前版本信息进行比对，如果提交的数据版本号大于数据库表当前版本号，则予以更新，否则认为是过期数据。

Hibernate为乐观锁提供了3中实现：

1. 基于version

2. 基于timestamp

3. 为遗留项目添加添加乐观锁 

配置基于version的乐观锁：

	<?xml version="1.0" encoding="utf-8"?>
	<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN" "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
	
	<hibernate-mapping>
	    <class name="com.suxiaolei.hibernate.pojos.People" table="people">
	        <id name="id" type="string">
	            <column name="id"></column>
	            <generator class="uuid"></generator>
	        </id>
	        
	        <!-- version标签用于指定表示版本号的字段信息 -->
	        <version name="version" column="version" type="integer"></version>
	
	        <property name="name" column="name" type="string"></property>
	        
	    </class>
	</hibernate-mapping>

配置基于timestamp的乐观锁：


	<?xml version="1.0" encoding="utf-8"?>
	<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN" "http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd">
	
	<hibernate-mapping>
	    <class name="com.suxiaolei.hibernate.pojos.People" table="people">
	        <id name="id" type="string">
	            <column name="id"></column>
	            <generator class="uuid"></generator>
	        </id>
	        
	<!-- timestamp标签用于指定表示版本号的字段信息


