+++
tags = ["hibernate"]
title = "hibernate.cfg.xml配置详解"
draft = false
date = "2017-02-08T10:58:24+02:00"

+++

非spring整合情况时，hibernate.cfg.xml的配置：

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







与spring整合后就在applicationContext.xml中配置

	 <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource"
          destroy-method="close">
        <!-- MySQL5 -->
        <property name="driverClass" value="${driverClassName}"></property>
        <property name="jdbcUrl" value="${url}"></property>
        <property name="user" value="${username}"></property>
        <property name="password" value="${password}"></property>
        <property name="maxPoolSize" value="40"></property>
        <property name="minPoolSize" value="1"></property>
        <property name="initialPoolSize" value="1"></property>
        <property name="maxIdleTime" value="20"></property>
    </bean>

    <!-- session工厂 -->
    <bean id="sessionFactory"
          class="org.springframework.orm.hibernate4.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
        <property name="packagesToScan" value="com.saudio.entity" />
        <property name="hibernateProperties">
            <props>
                <!--<prop key="hibernate.hbm2ddl.auto">${hibernate.hbm2ddl.auto}</prop>-->
                <prop key="hibernate.dialect">${hibernate.dialect}</prop>
                <prop key="hibernate.show_sql">${hibernate.show_sql}</prop>
                <prop key="hibernate.format_sql">${hibernate.format_sql}</prop>
            </props>
        </property>
    </bean>


整合后一些sessionFactory（非dataSource）的配置可以放在配置文件，然后sessionFactory引用配置。

	<hibernate-configuration>
	    <session-factory>
	        <!-- 配置Hibernate的基本属性 -->
	        <!-- 1.数据源配置到IOC容器中 -->
	        <!-- 2.关联的.hbm.xml也在IOC容器配置SessionFactory实例 -->
	        <!-- 3.配置Hibernate的基本属性：方言，SQL显示及格式化，生成数据表的策略以及二级缓存 -->
	        <property name="hibernate.dialect">org.hibernate.dialect.MySQL5Dialect</property>
	        <property name="hibernate.show_sql">true</property>
	        <property name="hbm2ddl.auto">update</property>
	    </session-factory>
	</hibernate-configuration>




application.xml

	<context:component-scan base-package="com.demo.ssm"></context:component-scan>
    <bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
        <property name="driverClassName" value="com.mysql.jdbc.Driver" />
        <property name="url" value="jdbc:mysql://localhost/test" />
        <property name="username" value="root"></property>
        <property name="password" value="281889"></property>
    </bean>  
    <bean id="sessionFactory" class="org.springframework.orm.hibernate4.LocalSessionFactoryBean" lazy-init="false">
        <!-- 注入datasource，给sessionfactoryBean内setdatasource提供数据源 -->
        <property name="dataSource" ref="dataSource" />

        <property name="configLocation" value="classpath:hibernate.cfg.xml"></property>
        <!-- //加载实体类的映射文件位置及名称 -->

        <property name="mappingLocations" value="classpath:com/demo/ssm/po/*.hbm.xml"></property>

    </bean>  
    
    <!-- 配置Spring声明式事务 -->
    <bean id="transactionManager" class="org.springframework.orm.hibernate4.HibernateTransactionManager">
        <property name="sessionFactory" ref="sessionFactory"></property>
    </bean> 
    <!-- 配置事务事务属性 -->
     <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <tx:attributes>
            <tx:method name="get*" read-only="true"/>
            <tx:method name="*"/>
        </tx:attributes>
    </tx:advice>
    <!-- 配置事务切点，并把切点和事务属性关联起来 -->
    <aop:config>
        <aop:pointcut expression="execution(* com.demo.ssm.daoImpl.*.*(..))" id="txPointcut"/>
        <aop:advisor advice-ref="txAdvice" pointcut-ref="txPointcut"/>
    </aop:config>

