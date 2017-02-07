+++
tags = ["spring"]
title = "spring生命周期"
draft = false
date = "2017-02-07T22:54:24+02:00"

+++





##### spring bean 对象 创建，初始化，销毁

bean到底是在什么时候才进行实例化的呢


bean对象无外乎是在以下两个时刻进行实例化的：

1. 调用getBean()方法时。

2. Spring容器启动时。

bean对象到底是在哪个时刻进行实例化的，这与Bean的作用域有着某种联系


当配置单个bean属性 lazy-init=“true” ，会在getBean时再创建。

默认是在spring容器启动时。

如果想对所有bean都应用延迟初始化，可以在根节点beans设置default-lazy-init=“true”

	 <bean id="personService" class="cn.itcast.service.impl.PersonServiceBean" scope="prototype"></bean>

当bean的作用域为prototype时，bean对象将会在调用getBean()方法时进行创建。



初始化方法：

	<bean id="personService" class="cn.itcast.service.impl.PersonServiceBean" init-method="init"></bean>


定义在创建对象后调用对象的init()方法进行初始化。

销毁：

	 destroy-method="destroy" 


在要销毁的bean添加上面属性，则会在销毁时调用方法。

bean对象到底是什么时候销毁的呢？答案是：如果没有人为地删除它，默认该bean一直在Spring容器中，也就是说随着Spring容器的关闭，该bean才会被销毁