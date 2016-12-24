+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "ssh 搭建全过程"
tags = [
  "framework"
,"java"
]


	
1. maven创建web项目

		mvn archetype:generate -DgroupId=com.zhw -DartifactId=sblog -DarchetypeArtifactId=maven-archetype-webapp -DinteractivMode=false -DarchetypeCatalog=internal
	
	

	-DinteractivMode: 是否开启交互模式，自测没什么卵用
	-DarchetypeCatalog=internal： 不使用国外资源库,防止没外网时一直等待.


2. main目录下创建java文件夹，并idea中右键设置为source Root



pom.xml


	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.bcode</groupId>
	<artifactId>bcode</artifactId>
	<packaging>war</packaging>
	<version>1.0-SNAPSHOT</version>
	<name>bcode</name>
	<url>http://maven.apache.org</url>

	<properties>
    <spring.version>4.0.4.RELEASE</spring.version>
    <hibernate.version>4.3.5.Final</hibernate.version>
	</properties>

	<dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>javax.servlet.jsp.jstl</groupId>
      <artifactId>javax.servlet.jsp.jstl-api</artifactId>
      <version>1.2.1</version>
    </dependency>
    <dependency>
      <groupId>taglibs</groupId>
      <artifactId>standard</artifactId>
      <version>1.1.2</version>
    </dependency>
    <dependency>
      <groupId>tomcat</groupId>
      <artifactId>servlet-api</artifactId>
      <version>5.5.23</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>tomcat</groupId>
      <artifactId>jsp-api</artifactId>
      <version>5.5.23</version>
      <scope>provided</scope>
    </dependency>

    <!-- 文件上传 -->
    <dependency>
      <groupId>commons-fileupload</groupId>
      <artifactId>commons-fileupload</artifactId>
      <version>1.3.1</version>
    </dependency>
    <!-- Apache Commons IO -->
    <dependency>
      <groupId>commons-io</groupId>
      <artifactId>commons-io</artifactId>
      <version>2.4</version>
    </dependency>

    <dependency>
      <groupId>org.hibernate</groupId>
      <artifactId>hibernate-validator</artifactId>
      <version>5.1.2.Final</version>
    </dependency>
    <dependency>
      <groupId>org.codehaus.jackson</groupId>
      <artifactId>jackson-mapper-asl</artifactId>
      <version>1.9.13</version>
    </dependency>

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-orm</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.hibernate</groupId>
      <artifactId>hibernate-core</artifactId>
      <version>${hibernate.version}</version>
    </dependency>

    <dependency>
      <groupId>c3p0</groupId>
      <artifactId>c3p0</artifactId>
      <version>0.9.1.2</version>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.31</version>
    </dependency>

    <!-- log4j  -->
    <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.17</version>
    </dependency>

    <!-- https://mvnrepository.com/artifact/org.apache.commons/commons-lang3 -->
    <dependency>
      <groupId>org.apache.commons</groupId>
      <artifactId>commons-lang3</artifactId>
      <version>3.4</version>
    </dependency>

    <!-- redis.properties -->
    <dependency>
      <groupId>redis.clients</groupId>
      <artifactId>jedis</artifactId>
      <version>2.1.0</version>
    </dependency>


    <!-- gson -->
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.7</version>
    </dependency>



    <!-- amazon -->
    <dependency>
      <groupId>com.amazonaws</groupId>
      <artifactId>aws-java-sdk-s3</artifactId>
    </dependency>

			</dependencies>

	<dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-bom</artifactId>
        <version>1.11.22</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
	</dependencyManagement>

	<build>
    <finalName>bcode</finalName>

    <plugins>
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.1</version>
        <configuration>
          <port>9090</port>
          <path>/</path>
          <uriEncoding>UTF-8</uriEncoding>
          <finalName>bcode</finalName>
          <server>tomcat7</server>
        </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>1.6</source>
          <target>1.6</target>
        </configuration>
      </plugin>


	
      <!-- Hibernate生成实体配置 -->
      <!--<plugin>-->
        <!--<groupId>org.codehaus.mojo</groupId>-->
        <!--<artifactId>hibernate3-maven-plugin</artifactId>-->
        <!--<version>2.2</version>-->

        <!--<dependencies>-->
          <!--<dependency>-->
            <!--<groupId>mysql</groupId>-->
            <!--<artifactId>mysql-connector-java</artifactId>-->
            <!--<version>5.1.21</version>-->
          <!--</dependency>-->
          <!--<dependency>-->
            <!--<groupId>cglib</groupId>-->
            <!--<artifactId>cglib</artifactId>-->
            <!--<version>2.2</version>-->
          <!--</dependency>-->
        <!--</dependencies>-->

        <!--<configuration>-->
          <!--<components>-->
            <!--<component>-->
              <!--<name>hbm2java</name>-->
              <!--<outputDirectory>src/main/java/</outputDirectory>-->
              <!--&lt;!&ndash; 主要用于反向控制数据库引擎通过JDBC连接数据 &ndash;&gt;-->
              <!--<implementation>jdbcconfiguration</implementation>-->
            <!--</component>-->
          <!--</components>-->
          <!--<componentProperties>-->
            <!--&lt;!&ndash; Hibernate配置文件 &ndash;&gt;-->
            <!--<configurationfile>src/main/resources/properties/hibernate.cfg.xml </configurationfile>-->
            <!--&lt;!&ndash;-->
            <!--如果设为true将会生成JPA的元素注解-->
            <!--使用annotations from-->
            <!--javax.persistence and org.hibernate.annotations-->
            <!--默认值是false-->
            <!--&ndash;&gt;-->
            <!--<ejb3>true</ejb3>-->
            <!--&lt;!&ndash; 指明生成java类的包名 &ndash;&gt;-->
            <!--<packagename>com.bcode.entity</packagename>-->
          <!--</componentProperties>-->
        <!--</configuration>-->
      <!--</plugin>-->
      <!-- Hibernate生成实体配置 -->



    </plugins>
 	 </build>
	</project>




3 . hibernate 反向生成实体


	pom.xml添加上面注释部分


	对应配置文件 hibernate.cfg.xml:

	<?xml version="1.0" encoding="utf-8"?>
	<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://hibernate.sourceforge.net/hibernate-configuration-3.0.dtd">
	<!-- 用于hibernate 反射实体类  -->
	<hibernate-configuration>
    <session-factory>
        <property name="hibernate.dialect">org.hibernate.dialect.MySQLInnoDBDialect</property>
        <property name="hibernate.connection.driver_class">com.mysql.jdbc.Driver</property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password">root</property>
        <property name="hibernate.connection.url">jdbc:mysql://localhost/bcode</property>
        <property name="hibernate.connection.shutdown">true</property>
    </session-factory>
	</hibernate-configuration>



pom.xml所在目录下 ：

	mvn hibernate3:hbm2java



4 .其他文件

	1.hibernate.properties

	hibernate.dialect=org.hibernate.dialect.MySQLInnoDBDialect
	driverClassName=com.mysql.jdbc.Driver
	url=jdbc:mysql://pcode.wiki:3306/bcode?useUnicode=true&characterEncoding=UTF-8
	username=root
	password=root
	hibernate.hbm2ddl.auto=none
	hibernate.show_sql=false
	hibernate.format_sql=false

	2.applicationContext.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:jee="http://www.springframework.org/schema/jee"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:tx="http://www.springframework.org/schema/tx" xmlns:mvc="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd
        http://www.springframework.org/schema/jee
        http://www.springframework.org/schema/jee/spring-jee-3.0.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx.xsd">



    <context:component-scan base-package="com.bcode"/>

    <context:property-placeholder location="classpath:/properties/hibernate.properties" />

    <!-- 使用C3P0数据源，MySQL数据库 -->
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
        <property name="packagesToScan" value="com.bcode.entity" />
        <property name="hibernateProperties">
            <props>
                <!--<prop key="hibernate.hbm2ddl.auto">${hibernate.hbm2ddl.auto}</prop>-->
                <prop key="hibernate.dialect">${hibernate.dialect}</prop>
                <prop key="hibernate.show_sql">${hibernate.show_sql}</prop>
                <prop key="hibernate.format_sql">${hibernate.format_sql}</prop>
            </props>
        </property>
    </bean>

    <context:annotation-config />


    <tx:annotation-driven transaction-manager="transactionManager" />

    <bean id="transactionManager"
          class="org.springframework.orm.hibernate4.HibernateTransactionManager">
        <property name="sessionFactory" ref="sessionFactory"></property>
    </bean>


	</beans>


	3.log4j.properties

	
	### set log levels ###
	log4j.rootLogger = debug,CONSOLE,logFile,errorfile
	
	
	### 设置引入jar包的级别为warn jar包无法打印warn及以上级别的信息，则达到屏蔽作用 ###
	log4j.logger.org.springframework=warn
	log4j.logger.org.hibernate=warn
	log4j.logger.com.mchange=warn
	org.apache.http.impl.conn.Wire.wire=warn
	
	
	### 输出到控制台 ###
	log4j.appender.CONSOLE = org.apache.log4j.ConsoleAppender
	log4j.appender.CONSOLE.Target = System.out
	log4j.appender.CONSOLE.layout = org.apache.log4j.PatternLayout
	log4j.appender.CONSOLE.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n
	
	### 输出到日志文件 ###
	#log4j.appender.logFile = org.apache.log4j.DailyRollingFileAppender
	#log4j.appender.logFile.File = /data/bcode_file/logs/normal/backup.log
	#log4j.appender.logFile.Threshold = warn
	#log4j.appender.logFile.DatePattern = '.'yyyy-MM-dd
	#log4j.appender.logFile.layout = org.apache.log4j.PatternLayout
	#log4j.appender.logFile.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n
	
	### 保存异常信息到单独文件 ###
	log4j.appender.errorfile = org.apache.log4j.DailyRollingFileAppender
	log4j.appender.errorfile.File = /data/bcode_file/logs/error/backup_error.log
	log4j.appender.errorfile.Threshold = ERROR
	log4j.appender.R.DatePattern = '.'yyyy-MM-dd
	log4j.appender.errorfile.layout = org.apache.log4j.PatternLayout
	log4j.appender.errorfile.layout.ConversionPattern = [%-5p] %d{yyyy-MM-dd HH:mm:ss,SSS} method:%l%n%m%n


	5. spring-dispatcher-servlet.xml

	<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.0.xsd
        http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd">

       <context:component-scan base-package="com.bcode"/>

       <mvc:annotation-driven />

       <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
              <property name="prefix" value="/web/"/>
              <property name="suffix" value=".jsp"/>
       </bean>

       <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
              <property name="defaultEncoding" value="UTF-8"/>
              <property name="maxUploadSize" value="1000000000"/>
       </bean>


       <mvc:default-servlet-handler />

       <mvc:interceptors>
              <mvc:interceptor>
                     <!--设置拦截的路径-->
                     <mvc:mapping path="/**" />
                     <bean class="com.bcode.common.filter.LoginInterceptor">
                            <property name="releaseUrls">
                                   <list>
                                          <value>/login</value>
                                          <value>/upload</value>
                                          <value>/getBg</value>
                                          <value>.css</value>
                                          <value>.js</value>
                                          <value>.png</value>
                                          <value>.woff</value>
                                          <value>.ttf</value>
                                          <value>.ico</value>
                                   </list>
                            </property>
                     </bean>
              </mvc:interceptor>
       </mvc:interceptors>


	</beans>



	6.web.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://java.sun.com/xml/ns/javaee"
         xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
         metadata-complete="true" version="3.0">

	  <servlet>
	    <servlet-name>spring-dispatcher</servlet-name>
	    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	  </servlet>
	  <servlet-mapping>
	    <servlet-name>spring-dispatcher</servlet-name>
	    <url-pattern>/</url-pattern>
	  </servlet-mapping>
	
	  <filter>
	    <filter-name>hibernateFilter</filter-name>
	    <filter-class>org.springframework.orm.hibernate4.support.OpenSessionInViewFilter</filter-class>
	  </filter>
	  <filter-mapping>
	    <filter-name>hibernateFilter</filter-name>
	    <url-pattern>/*</url-pattern>
	  </filter-mapping>
	
	  <context-param>
	    <param-name>contextConfigLocation</param-name>
	    <param-value>
	      classpath:/applicationContext.xml
	    </param-value>
	  </context-param>
	
	  <listener>
	    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	  </listener>
	
	</web-app>



5 .添加注解

	Controller:

		@Controller
		@RequestMapping() 


	
	userDaoImpl:
	
		@Repository("userDao")

	
	Service:

		@Service("userService")


	Entity:	

		@Data
		@EqualsAndHashCode(callSuper = false)








