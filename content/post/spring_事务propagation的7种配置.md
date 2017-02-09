
+++
tags = ["spring"]
title = "spring_事务propagation的7种配置"
draft = false
date = "2017-02-09T22:54:24+02:00"

+++



#####spring aop中的propagation的7种配置的意思

 
1.前言。 
在声明式的事务处理中，要配置一个切面，即一组方法，如


	<tx:advice id="txAdvice" transaction-manager="txManager">  
	    <tx:attributes>  
	        <tx:method name="find*" read-only="true" propagation="NOT_SUPPORTED" />  
	    </tx:attributes>  
	</tx:advice>  

其中就用到了propagation，表示打算对这些方法怎么使用事务，是用还是不用，其中propagation有七种配置，REQUIRED、SUPPORTS、MANDATORY、REQUIRES_NEW、NOT_SUPPORTED、NEVER、NESTED。默认是REQUIRED。
 
2.七种配置的意思 

下面是Spring中Propagation类的事务属性详解： 

	REQUIRED：支持当前事务，如果当前没有事务，就新建一个事务。这是最常见的选择。 
	
	SUPPORTS：支持当前事务，如果当前没有事务，就以非事务方式执行。 
	
	MANDATORY：支持当前事务，如果当前没有事务，就抛出异常。 
	
	REQUIRES_NEW：新建事务，如果当前存在事务，把当前事务挂起。 
	
	NOT_SUPPORTED：以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。 
	
	NEVER：以非事务方式执行，如果当前存在事务，则抛出异常。 
	
	NESTED：支持当前事务，如果当前事务存在，则执行一个嵌套事务，如果当前没有事务，就新建一个事务。