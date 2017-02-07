+++
tags = ["spring"]
title = "spring依赖注入"
draft = false
date = "2017-02-07T22:54:24+02:00"

+++


Spring提出了依赖注入的思想，即依赖类不由程序员实例化，而是通过Spring容器帮我们new指定实例并且将实例注入到需要该对象的类中。

依赖注入是面向接口编程，依赖倒转原则的体现，将调用类和实现类解耦，不依赖于具体实现。符合开闭原则，利于扩展。


##### 依赖注入方法：

##### 1.set注入：



最简单的注入方式


	package com.bless.springdemo.action; 
	public class SpringAction { 
	//注入对象springDao 
	private SpringDao springDao; 
	//一定要写被注入对象的set方法 
	public void setSpringDao(SpringDao springDao) { 
	this.springDao = springDao; 
	} 
	
	public void ok(){ 
	springDao.ok(); 
	} 
	}


spring.xml

	<!--配置bean,配置后该类由spring管理--> 
	<bean name="springAction" class="com.bless.springdemo.action.SpringAction"> 
	<!--(1)依赖注入,配置当前类中相应的属性--> 
	<property name="springDao" ref="springDao"></property> 
	</bean> 
	<bean name="springDao" class="com.bless.springdemo.dao.impl.SpringDaoImpl"></bean>



##### 2.构造器注入

	public class SpringAction { 
	//注入对象springDao 
	private SpringDao springDao; 
	private User user; 
	
	public SpringAction(SpringDao springDao,User user){ 
	this.springDao = springDao; 
	this.user = user; 
	System.out.println("构造方法调用springDao和user"); 
	} 
	
	public void save(){ 
	user.setName("卡卡"); 
	springDao.save(user); 
	} 
	} 

spring.xml


	<!--配置bean,配置后该类由spring管理--> 
	<bean name="springAction" class="com.bless.springdemo.action.SpringAction"> 
	<!--(2)创建构造器注入,如果主类有带参的构造方法则需添加此配置--> 
	<constructor-arg ref="springDao"></constructor-arg> 
	<constructor-arg ref="user"></constructor-arg> 
	</bean> 
	<bean name="springDao" class="com.bless.springdemo.dao.impl.SpringDaoImpl"></bean> 
	<bean name="user" class="com.bless.springdemo.vo.User"></bean> 


解决构造方法参数的不确定性，你可能会遇到构造方法传入的两参数都是同类型的，为了分清哪个该赋对应值，则需要进行一些小处理：
下面是设置index，就是参数位置：

	<bean name="springAction" class="com.bless.springdemo.action.SpringAction"> 
	<constructor-arg index="0" ref="springDao"></constructor-arg> 
	<constructor-arg index="1" ref="user"></constructor-arg> 
	</bean> 



另一种是设置参数类型：

	<constructor-arg type="java.lang.String" ref=""/>




##### 3.静态工厂的方法注入




	package com.bless.springdemo.factory; 
	
	import com.bless.springdemo.dao.FactoryDao; 
	import com.bless.springdemo.dao.impl.FactoryDaoImpl; 
	import com.bless.springdemo.dao.impl.StaticFacotryDaoImpl; 
	
	public class DaoFactory { 
	//静态工厂 
	public static final FactoryDao getStaticFactoryDaoImpl(){ 
	return new StaticFacotryDaoImpl(); 
	} 
	}




	public class SpringAction { 
	//注入对象 
	private FactoryDao staticFactoryDao; 
	
	public void staticFactoryOk(){ 
	staticFactoryDao.saveFactory(); 
	} 
	//注入对象的set方法 
	public void setStaticFactoryDao(FactoryDao staticFactoryDao) { 
	this.staticFactoryDao = staticFactoryDao; 
	} 
	} 




Spring的IOC配置文件，注意看<bean name="staticFactoryDao">指向的class并不是FactoryDao的实现类，而是指向静态工厂DaoFactory，并且配置 factory-method="getStaticFactoryDaoImpl"指定调用哪个工厂方法：


	<!--配置bean,配置后该类由spring管理--> 
	<bean name="springAction" class="com.bless.springdemo.action.SpringAction" > 
	<!--(3)使用静态工厂的方法注入对象,对应下面的配置文件(3)--> 
	<property name="staticFactoryDao" ref="staticFactoryDao"></property> 
	</property> 
	</bean> 
	<!--(3)此处获取对象的方式是从工厂类中获取静态方法--> 
	<bean name="staticFactoryDao" class="com.bless.springdemo.factory.DaoFactory" factory-method="getStaticFactoryDaoImpl"></bean> 



##### 4.实例工厂的方法注入

     实例工厂的意思是获取对象实例的方法不是静态的，所以你需要首先new工厂类，再调用普通的实例方法：


	public class DaoFactory { 
	//实例工厂 
		public FactoryDao getFactoryDaoImpl(){ 
		return new FactoryDaoImpl(); 
		} 
	}



	public class SpringAction { 
	//注入对象 
	private FactoryDao factoryDao; 
	
	public void factoryOk(){ 
	factoryDao.saveFactory(); 
	} 
	
	public void setFactoryDao(FactoryDao factoryDao) { 
	this.factoryDao = factoryDao; 
	} 
	} 

 最后看spring配置文件


	<!--配置bean,配置后该类由spring管理--> 
	<bean name="springAction" class="com.bless.springdemo.action.SpringAction"> 
	<!--(4)使用实例工厂的方法注入对象,对应下面的配置文件(4)--> 
	<property name="factoryDao" ref="factoryDao"></property> 
	</bean> 
	
	<!--(4)此处获取对象的方式是从工厂类中获取实例方法--> 
	<bean name="daoFactory" class="com.bless.springdemo.factory.DaoFactory"></bean> 
	<bean name="factoryDao" factory-bean="daoFactory" factory-method="getFactoryDaoImpl"></bean>


实例工厂方法需要 factory-bean 指向需要先创建的工厂对象，而不是静态的class，然后调用 factory-method="getFactoryDaoImpl".大同小异.



Spring IOC注入方式用得最多的是(1)(2)种，多写多练就会非常熟练。

另外注意：通过Spring创建的对象默认是单例的，如果需要创建多实例对象可以在<bean>标签后面添加一个属性：

	<bean name="..." class="..." scope="prototype">





##### 注解实现依赖注入

注解注入顾名思义就是通过注解来实现注入，

Spring和注入相关的常见注解有

**Autowired、Resource、Qualifier、Service、Controller、Repository、Component**。

Autowired是自动注入，自动从spring的上下文找到合适的bean来注入
Resource用来指定名称注入
Qualifier和Autowired配合使用，指定bean的名称
Service，Controller，Repository分别标记类是Service层类，Controller层类，数据存储层的类，spring扫描注解配置时，会标记这些类要生成bean。

Component是一种泛指，标记类是组件，spring扫描注解配置时，会标记这些类要生成bean。

上面的Autowired和Resource是用来修饰字段，构造函数，或者设置方法，并做注入的。而Service，Controller，Repository，Component则是用来修饰类，标记这些类要生成bean。