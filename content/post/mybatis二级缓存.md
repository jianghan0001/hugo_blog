+++
tags = ["mybatis"]
title = "mybatis缓存"
draft = false
date = "2017-02-08T12:54:24+02:00"

+++


[http://www.cnblogs.com/zemliu/archive/2013/08/05/3239014.html](http://www.cnblogs.com/zemliu/archive/2013/08/05/3239014.html "http://www.cnblogs.com/zemliu/archive/2013/08/05/3239014.html")



MyBatis缓存分为一级缓存和二级缓存

一级缓存

MyBatis的一级缓存指的是在一个Session域内,session为关闭的时候执行的查询会根据SQL为key被缓存(跟mysql缓存一样,修改任何参数的值都会导致缓存失效)


二级缓存

二级缓存就是global caching,它超出session范围之外,可以被所有sqlSession共享,它的实现机制和mysql的缓存一样,开启它只需要在mybatis的配置文件开启settings里的




![](http://i.imgur.com/ZxJMJGB.jpg)


以及在相应的Mapper文件(例如userMapper.xml)里开启

	<mapper namespace="dao.userdao">
	   ...  select statement ...
	       <!-- Cache 配置 -->
	    <cache
	        eviction="FIFO"
	        flushInterval="60000"
	        size="512"
	        readOnly="true" />
	</mapper>


![](http://i.imgur.com/QLneZb4.jpg)



实现序列化

    

由于二级缓存的数据不一定都是存储到内存中，它的存储介质多种多样，所以需要给缓存的对象执行序列化。

如果该类存在父类，那么父类也要实现序列化。


![](http://i.imgur.com/6ejtIqs.jpg)



禁用二级缓存

该statement中设置userCache=false可以禁用当前select语句的二级缓存，即每次查询都是去数据库中查询，默认情况下是true，即该statement使用二级缓存。


![](http://i.imgur.com/YiDJX0H.jpg)

刷新二级缓存


![](http://i.imgur.com/2q9mzHf.jpg)








什么是查询缓存

    

Mybatis的一级缓存是指SqlSession。一级缓存的作用域是一个SqlSession。Mybatis默认开启一级缓存。

在同一个SqlSession中，执行相同的查询SQL，第一次会去查询数据库，并写到缓存中；第二次直接从缓存中取。当执行SQL时两次查询中间发生了增删改操作，则SqlSession的缓存清空。

 

Mybatis的二级缓存是指mapper映射文件。二级缓存的作用域是同一个namespace下的mapper映射文件内容，多个SqlSession共享。Mybatis需要手动设置启动二级缓存。

在同一个namespace下的mapper文件中，执行相同的查询SQL，第一次会去查询数据库，并写到缓存中；第二次直接从缓存中取。当执行SQL时两次查询中间发生了增删改操作，则二级缓存清空。


![](http://i.imgur.com/Gq5BrBh.jpg)




一级缓存区域是根据SqlSession为单位划分的。

 

每次查询会先去缓存中找，如果找不到，再去数据库查询，然后把结果写到缓存中。Mybatis的内部缓存使用一个HashMap，key为hashcode+statementId+sql语句。Value为查询出来的结果集映射成的java对象。

 

SqlSession执行insert、update、delete等操作commit后会清空该SQLSession缓存





![](http://i.imgur.com/O13ED9n.jpg)

二级缓存是mapper级别的。Mybatis默认是没有开启二级缓存。

 

第一次调用mapper下的SQL去查询用户信息。查询到的信息会存到该mapper对应的二级缓存区域内。

第二次调用相同namespace下的mapper映射文件中相同的SQL去查询用户信息。会去对应的二级缓存内取结果。

如果调用相同namespace下的mapper映射文件中的增删改SQL，并执行了commit操作。此时会清空该namespace下的二级缓存。



##### mybatis延迟加载

	<!-- 开启延迟加载 -->
	    <settings>
	        <!-- lazyLoadingEnabled:延迟加载启动，默认是false -->
	        <setting name="lazyLoadingEnabled" value="true"/>
	        <!-- aggressiveLazyLoading：积极的懒加载，false的话按需加载，默认是true -->
	        <setting name="aggressiveLazyLoading" value="false"/>
	         
	        <!-- 开启二级缓存，默认是false -->
	        <setting name="cacheEnabled" value="true"/>
	    </settings>



