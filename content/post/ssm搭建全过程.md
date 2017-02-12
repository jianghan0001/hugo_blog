+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "ssm搭建全过程"
tags = [
  "framework"
,"java"
]
+++
1. maven创建web项目

	mvn archetype:generate -DgroupId=com.zhw -DartifactId=sblog -DarchetypeArtifactId=maven-archetype-webapp -DinteractivMode=false -DarchetypeCatalog=internal
	
	

	-DinteractivMode: 是否开启交互模式，自测没什么卵用
	-DarchetypeCatalog=internal： 不使用国外资源库,防止没外网时一直等待.

2. main目录下创建java文件夹，并idea中右键设置为source Root



3. pom.xml中配置文件及依赖包及插件配置

		<!-- spring mybatis jdk aspectj activiti 版本属性-->  

	    <properties>
	    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
	    <jdk.version>1.7</jdk.version>
	    <spring.version>3.2.13.RELEASE</spring.version>
	    <mybatis.version>3.2.7</mybatis.version>
	    <aspectj.version>1.7.3</aspectj.version>
	    <activiti.version>5.17.0</activiti.version>
	      </properties>
    

   
		<!--  添加profiles 配置文件  profile:扼要描述 -->

		<profiles>
		<profile>
		  <id>mine</id>
		  <activation>
		<activeByDefault>true</activeByDefault>
		  </activation>
		  <build>
		<filters>
		  <filter>src/main/resources/filters/filter-mine.properties</filter>
		</filters>
		  </build>
		</profile>
		<profile>
		  <id>release</id>
		  <activation>
		<activeByDefault>false</activeByDefault>
		  </activation>
		  <build>
		<filters>
		  <filter>src/main/resources/filters/filter-release.properties</filter>
		</filters>
		  </build>
		</profile>
		 </profiles>
		

		//项目配置文件：
![](http://i.imgur.com/bCv3gXM.png)
	

  	
    

<!--  maven 中央版本库 指定 -->

  	<repositories>   //maven 中央版本库
    <repository>
      <id>central</id>
      <name>Central Repository</name>
      <url>http://repo.maven.apache.org/maven2</url>
      <snapshots>
        <enabled>true</enabled>
      </snapshots>
    </repository>
  	</repositories>


 	<!--  maven 一大堆插件 与 tomcat插件 -->

 	<build>
    <finalName>web Maven Webapp</finalName>
    <resources>
      <resource>
        <directory>src/main/resources</directory>
        <filtering>true</filtering>
      </resource>
    </resources>

    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>2.6</version>
        <configuration>
          <skipTests>true</skipTests>
        </configuration>
      </plugin>

      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <!-- 指定最新插件的版本号-->
        <version>2.3.2</version>
        <configuration>
          <!-- 指定高版本的源码和编译后的字节码文件-->
          <source>${jdk.version}</source>
          <target>${jdk.version}</target>
          <optimize>true</optimize>
          <debug>true</debug>
          <showDeprecation>false</showDeprecation>
          <showWarnings>false</showWarnings>
        </configuration>
      </plugin>

      <!-- enforcer插件, 避免被依赖的依赖引入过期的jar包 -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-enforcer-plugin</artifactId>
        <version>1.3.1</version>
        <executions>
          <execution>
            <id>enforce-banned-dependencies</id>
            <goals>
              <goal>enforce</goal>
            </goals>
            <configuration>
              <rules>
                <!-- <requireMavenVersion>
                    <version>3.0.3</version>
                </requireMavenVersion> -->
                <requireJavaVersion>
                  <version>1.7</version>
                </requireJavaVersion>
                <requireUpperBoundDeps />
                <bannedDependencies>
                  <searchTransitive>true</searchTransitive>
                  <excludes>
                    <!-- <exclude>commons-logging</exclude> -->
                    <exclude>aspectj:aspectj*</exclude>
                    <exclude>org.springframework:</exclude>
                  </excludes>
                  <includes>
                    <include>org.springframework:*:3.2.*</include>
                  </includes>
                </bannedDependencies>
              </rules>
              <fail>true</fail>
            </configuration>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-resources-plugin</artifactId>
        <version>2.7</version>
        <dependencies>
          <dependency>
            <groupId>org.apache.maven.shared</groupId>
            <artifactId>maven-filtering</artifactId>
            <version>1.3</version>
          </dependency>
        </dependencies>
      </plugin>
      <!-- 需要指定WebRoot路径或者web.xml路径 -->
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <version>2.1.1</version>
        <configuration>
          <warName>${project.artifactId}</warName>
          <webResources>
            <resource>
              <!-- this is relative to the pom.xml directory -->
              <directory>src/main/webapp</directory>
            </resource>
          </webResources>
        </configuration>
      </plugin>
      <!-- tomcat plugin -->
      <plugin>
        <groupId>org.apache.tomcat.maven</groupId>
        <artifactId>tomcat7-maven-plugin</artifactId>
        <version>2.2</version>
        <configuration>
          <path>/</path>
          <port>8080</port>
          <uriEncoding>UTF-8</uriEncoding>
          <url>http://127.0.0.1/manager</url>
          <server>tomcat7</server>
          <contextReloadable>true</contextReloadable>
          <warSourceDirectory>src/main/webapp</warSourceDirectory>
          <contextReloadable>false</contextReloadable>
        </configuration>
      </plugin>

    </plugins>

  	</build>



<!-- spring 依赖 -->

<!-- spring beans-->
	//spring 依赖

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-beans</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context-support</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring mvc -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-web</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-webmvc</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring AOP -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aop</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjrt</artifactId>
      <version>${aspectj.version}</version>
    </dependency>
    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjweaver</artifactId>
      <version>${aspectj.version}</version>
      <scope>runtime</scope>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-tx</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <!-- spring orm -->
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-orm</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>${spring.version}</version>
    </dependency>


<!-- mybatis -->
	//mybatis
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <version>${mybatis.version}</version>
    </dependency>
    <dependency>
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis-spring</artifactId>
      <version>1.2.1</version>
    </dependency>


<!-- mysql -->
	//mysql

    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>5.1.24</version>
    </dependency>

	<!-- druid alibaba 数据库相关库 -->
    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>druid</artifactId>
      <version>1.0.1</version>
    </dependency>

<!-- Apache Commons Upload -->

	//springmvc 文件上传需要的依赖

    <dependency>
      <groupId>commons-io</groupId>
      <artifactId>commons-io</artifactId>
      <version>1.3.2</version>
    </dependency>

    <dependency>
      <groupId>commons-fileupload</groupId>
      <artifactId>commons-fileupload</artifactId>
      <version>1.2.1</version> <!-- makesure correct version here -->
    </dependency>



	//去除entity中po里getset方法,idea中编写时添加lombok插件
 	<!--@Data   ：注解在类上；提供类所有属性的 getting 和 setting 方法，此外还提供了equals、canEqual、hashCode、toString 方法-->
    <!--@Setter：注解在属性上；为属性提供 setting 方法-->
    <!--@Getter：注解在属性上；为属性提供 getting 方法-->
    <!--@Log4j ：注解在类上；为类提供一个 属性名为log 的 log4j 日志对象-->
    <!--@NoArgsConstructor：注解在类上；为类提供一个无参的构造方法-->
    <!--@AllArgsConstructor：注解在类上；为类提供一个全参的构造方法-->

    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <version>1.12.2</version><!--1.16.4-->
      <scope>provided</scope>
    </dependency>



	<!-- j2ee web spec -->
	//j2se的依赖，jstl依赖

    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>servlet-api</artifactId>
      <version>2.5</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>jstl</artifactId>
      <version>1.2</version>
    </dependency>

	//google gson依赖,json解析
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.2.4</version>
    </dependency>


	 <!-- log4j 依赖 -->
    <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.17</version>
    </dependency>
	
	
	<!-- memcached依赖 -->
	 <dependency>
      <groupId>net.spy</groupId>
      <artifactId>spymemcached</artifactId>
      <version>2.10.3</version>
    </dependency>



4 .  maven反射生成mybatis的实体，配置文件

	pom.xml中

		<plugin>
            <groupId>org.mybatis.generator</groupId>
            <artifactId>mybatis-generator-maven-plugin</artifactId>
            <version>1.3.2</version>
            <configuration>
                <verbose>true</verbose>
                <overwrite>true</overwrite>
            </configuration>
    </plugin>

	插件默认会读到src/main/resources目录下的generatorConfig.xml 文件。

	<?xml version="1.0" encoding="UTF-8" ?>
	<!DOCTYPE generatorConfiguration PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN" "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd" >
	<generatorConfiguration>

    <classPathEntry
            location="E:\mysql-connector-java-5.1.22-bin.jar" />


    <context id="context1" targetRuntime="MyBatis3">

        <jdbcConnection driverClass="com.mysql.jdbc.Driver"
                        connectionURL="jdbc:mysql://localhost:3306/sblog?useUnicode=true&amp;characterEncoding=UTF-8"
                        userId="root" password="will2016@" />

        <javaModelGenerator targetPackage="com.sblog.po"
                            targetProject="E:\pro\sblog\sblog\src\main\java" />

        <javaClientGenerator targetPackage="com.sblog.dao"
                         targetProject="E:\pro\sblog\sblog\src\main\java" type="XMLMAPPER" />

        <sqlMapGenerator targetPackage="mybatis"
            targetProject="E:\pro\sblog\sblog\src\main\resources"  />

        <table schema="CL_DEMO" tableName="user" />

        <!--<table schema="CL_DEMO" tableName="tb_role" />-->
        <!--<table schema="CL_DEMO" tableName="tb_permission" />-->
        <!--<table schema="CL_DEMO" tableName="tb_role_user" />-->
        <!--<table schema="CL_DEMO" tableName="tb_permission_role" />-->

    </context>

	</generatorConfiguration>
	

	pom.xml目录下执行下列代码:

	mvn mybatis-generator:generate


	生成的example之类的东西没有用，可以删除


5 . 各个配置文件

	1.filter-mine.properties

	# database
	m.jdbc.driverClassName=com.alibaba.druid.pool.DruidDataSource
	m.jdbc.host=127.0.0.1
	m.jdbc.database=sblog
	m.jdbc.url=jdbc:mysql://${m.jdbc.host}:3306/${m.jdbc.database}?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull
	m.jdbc.username=root
	m.jdbc.password=will2016@
	m.jdbc.maxPoolSize=10
	m.jdbc.minPoolSize=3
	m.jdbc.initialPoolSize=3
	
	##importDatabase
	#m.jdbc.import.host=127.0.0.1
	#m.jdbc.import.database=test
	#m.jdbc.import.url=jdbc:mysql://${m.jdbc.import.host}:3306/${m.jdbc.import.database}?useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull
	#m.jdbc.import.username=root
	#m.jdbc.import.password=
	#memcache
	#m.server1=127.0.0.1:11211
	
	#project path
	m.contextPath=http://127.0.0.1:8080
	
	# static resource
	m.staticServer = http://127.0.0.1:8080
	
	m.pdfpath=E:\\pdf
	
	#image upload server
	m.uploadImageServer=http://zms.wiki100.net
	m.staticImage=http://zms.wiki100.net
	m.projectName=cotton
	
	#email
	m.email.host=smtp.13.com
	m.email.username=hykctp1@163.com
	m.email.password=1q2w3e4r5t
	
	#cookie
	
	#Solr
	m.solrUrl=http://114.215.138.135:8087/solr
	
	#excelPath
	m.excelPath=

	

	2. applicationContext.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:jdbc="http://www.springframework.org/schema/jdbc"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd"
       default-lazy-init="true" >

	

    <!-- 配置文件加载 全局配置文件 -->
    <bean id="propertyConfigurer"
          class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
        <property name="locations">
            <list>
                <value>classpath:project.properties</value>
            </list>
        </property>
    </bean>


	<!-- 数据源配置 -->

    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="${jdbc.url}"/>
        <property name="username" value="${jdbc.username}"/>
        <property name="password" value="${jdbc.password}"/>
        <!-- 配置初始化大小、最小、最大 -->
        <property name="initialSize" value="${jdbc.initialPoolSize}" />
        <property name="minIdle" value="${jdbc.minPoolSize}" />
        <property name="maxActive" value="${jdbc.maxPoolSize}" />
        <!-- 配置获取连接等待超时的时间 -->
        <property name="maxWait" value="60000" />
        <!-- 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒 -->
        <property name="timeBetweenEvictionRunsMillis" value="60000" />
        <!-- 配置一个连接在池中最小生存的时间，单位是毫秒 -->
        <property name="minEvictableIdleTimeMillis" value="300000" />
        <property name="validationQuery" value="SELECT 'x'" />
        <property name="testWhileIdle" value="true" />
        <property name="testOnBorrow" value="false" />
        <property name="testOnReturn" value="false" />
        <!-- 打开PSCache，并且指定每个连接上PSCache的大小 -->
        <!--  <property name="poolPreparedStatements" value="false" /> -->
        <!--  <property name="maxPoolPreparedStatementPerConnectionSize" value="20" /> -->
        <!-- 配置监控统计拦截的filters -->
        <property name="filters" value="stat" />
    </bean>

    <!-- 本项目数据源代码 对数据源及mapper文件的配置 -->

    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">

        <property name="dataSource" ref="dataSource" />
        <!-- 显式指定Mapper文件位置 -->
        <property name="configLocation"  value="classpath:/SqlMapConfig.xml"/>
        <!-- 通配符指定Mapper.xml -->
        <property name="mapperLocations" value="classpath:/mybatis/**/*Mapper.xml" />
        <!-- 自动扫描entity目录, 省掉Configuration.xml里的手工配置 -->
        <property name="typeAliasesPackage" value="com.sblog.po" />

    </bean>
    <bean id="sqlSessionMain" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>

	</beans>


	3 . log4j.properties

	
	### set log levels ###
	log4j.rootLogger = debug,CONSOLE,errorfile
	
	
	### 设置引入jar包的级别为warn jar包无法打印warn及以上级别的信息，则达到屏蔽作用 ###
	log4j.logger.org.springframework=warn
	log4j.logger.org.hibernate=warn
	log4j.logger.com.mchange=warn
	###显示SQL语句部分
	log4j.logger.com.yxy.web=debug
	log4j.logger.com.ibatis.common.jdbc.SimpleDataSource=debug
	log4j.logger.com.ibatis.common.jdbc.ScriptRunner=debug
	log4j.logger.com.ibatis.sqlmap.engine.impl.SqlMapClientDelegate=debug
	log4j.logger.java.sql.Connection=debug
	log4j.logger.java.sql.Statement=debug
	log4j.logger.java.sql.PreparedStatement=debug
	
	
	
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





	5. project.properties

	#db
	jdbc.driverClassName=${m.jdbc.driverClassName}
	jdbc.url=${m.jdbc.url}
	jdbc.username=${m.jdbc.username}
	jdbc.password=${m.jdbc.password}
	jdbc.maxPoolSize=${m.jdbc.maxPoolSize}
	jdbc.minPoolSize=${m.jdbc.minPoolSize}
	jdbc.initialPoolSize=${m.jdbc.initialPoolSize}
	jdbc.idleConnectionTestPeriod=1800
	jdbc.maxIdleTime=3600
	
	#importdb
	jdbc.import.url=${m.jdbc.import.url}
	jdbc.import.username=${m.jdbc.import.username}
	jdbc.import.password=${m.jdbc.import.password}
	
	#memcach start
	server1=${m.server1}
	server2=${m.server1}
	opTimeout=3
	opTimeoutBulk=3
	retry=1
	readBufSize=16384
	opQueueLen=16384
	expHour=24
	#memcach end
	
	#项目路径
	contextPath=${m.contextPath}
	#图片、CSS、js静态资源文件地址
	staticServer = ${m.staticServer}
	
	#上传服务用服务器地址，访问时用staticImage，数据库中不存储域名
	uploadImageServer=${m.uploadImageServer}
	staticImage=${m.staticImage}
	projectName=${m.projectName}
	
	
	# user relogin
	email.host=${m.email.host}
	email.username=${m.email.username}
	email.password=${m.email.password}
	
	
	pdfpath=${m.pdfpath}
	# solr服务器url
	solrUrl=${m.solrUrl}
	
	#excelPath
	excelPath=${m.excelPath}




	6. spring-mvc.xml

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
	   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	   xmlns:context="http://www.springframework.org/schema/context"
	   xmlns:mvc="http://www.springframework.org/schema/mvc"
	   xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd">

	<!-- 包中的所有类进行扫描，以完成Bean创建和自动依赖注入的功能 -->
	<context:component-scan  base-package="com.sblog" />

	mvc:annotation-driven content-negotiation-manager="contentNegotiationManager">
		<mvc:message-converters register-defaults="true">
			<!-- 将StringHttpMessageConverter的默认编码设为UTF-8 -->
			<bean class="org.springframework.http.converter.StringHttpMessageConverter">
				<constructor-arg value="UTF-8" />
			</bean>
	</mvc:message-converters>
	</mvc:annotation-driven>
	<!-- <mvc:resources mapping="/static/**" location="/static/"/> -->
	<mvc:default-servlet-handler />


	<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<property name="prefix" value="/web/"/>
		<property name="suffix" value=".jsp"/>
		<property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
	</bean>

	<bean id="contentNegotiationManager" class="org.springframework.web.accept.ContentNegotiationManagerFactoryBean">
		<property name="mediaTypes" >
			<value>
				json=application/json
				xml=application/xml
			</value>
		</property>
	</bean>

	<!-- 文件上传限制大小 -->
	<bean id="multipartResolver"
		  class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
		<!-- set the max upload size 1000MB -->
		<property name="maxUploadSize">
			<value>1048576000</value>
		</property>
		<property name="maxInMemorySize">
			<value>4096</value>
		</property>
	</bean>


	<!-- 将Controller抛出的异常转到特定View, 保持SiteMesh的装饰效果 -->
	<bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
		<property name="exceptionMappings">
			<props>
				<prop key="org.apache.shiro.authz.UnauthorizedException">/WEB-INF/view/common/error/403</prop>
				<prop key="java.lang.Throwable">/common/error</prop>
			</props>
		</property>
	</bean>


	7. SqlMapConfig.xml

	<?xml version="1.0" encoding="UTF-8" ?>
	<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
	<configuration>
 
	<settings>
        <setting name="lazyLoadingEnabled" value="false"/>
        <setting name="cacheEnabled" value="false"/>
    </settings>
	<typeAliases>
		<!-- 所有用到的实体类无需填写 -->
	</typeAliases>
	<!-- Mapper.xml无需挨个引入，全部命名规范：以Mapper.xml结尾会自动引入  如：publicMapper.xml-->
	</configuration>



	8. web.xml

		<!DOCTYPE web-app PUBLIC
	 "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
	 "http://java.sun.com/dtd/web-app_2_3.dtd" >
	
	<web-app>
	  <display-name>sblog</display-name>
	  <!-- 编码 -->
	  <filter>
	    <filter-name>encoding</filter-name>
	    <filter-class>
	      org.springframework.web.filter.CharacterEncodingFilter
	    </filter-class>
	    <init-param>
	      <param-name>encoding</param-name>
	      <param-value>utf-8</param-value>
	    </init-param>
	    <init-param>
	      <param-name>forceEncoding</param-name>
	      <param-value>true</param-value>
	    </init-param>
	  </filter>
	  <filter-mapping>
	    <filter-name>encoding</filter-name>
	    <url-pattern>/*</url-pattern>
	  </filter-mapping>
	
	  <context-param>
	    <param-name>contextConfigLocation</param-name>
	    <param-value>classpath:applicationContext.xml</param-value>
	  </context-param>
	  <listener>
	    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
	  </listener>
	  <listener>
	    <listener-class> org.springframework.web.util.IntrospectorCleanupListener</listener-class>
	  </listener>
	  <servlet>
	    <servlet-name>springmvc</servlet-name>
	    <servlet-class>
	      org.springframework.web.servlet.DispatcherServlet
	    </servlet-class>
	    <init-param>
	      <param-name>contextConfigLocation</param-name>
	      <param-value>classpath:spring-mvc.xml</param-value>
	    </init-param>
	    <load-on-startup>1</load-on-startup>
	  </servlet>
	
	  <servlet-mapping>
	    <servlet-name>springmvc</servlet-name>
	    <url-pattern>/</url-pattern>
	  </servlet-mapping>
	
	  <!-- 首页 -->
	  <welcome-file-list>
	    <welcome-file>index.jsp</welcome-file>
	  </welcome-file-list>
	
	</web-app>

	


6 . 实现dao，并添加BaseDao 和 BaseDaoImpl 类，并继承

	BaseDao:
	
	package com.sblog.dao.base;

	import java.util.List;

	/**
	 * Created by hongwei on 2016/12/1.
	 */
	public interface BaseDao {
	
	    public <T> T selectOne(String sqlKey, Object params);
	    public <T> List<T> selectList(String sqlKey, Object params);
	
	}



	BaseDaoImpl:



	package com.sblog.dao.base;
	
	import org.apache.ibatis.session.SqlSession;
	
	import javax.annotation.Resource;
	import java.util.List;
	
	/**
	 * Created by hongwei on 2016/12/1.
	 */
	public class BaseDaoImpl implements BaseDao {


    public SqlSession sqlSession;

    public SqlSession getSqlSession() {
        return sqlSession;
    }

    @Resource(name = "sqlSessionMain")
    public void setSqlSession1(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public <T> T selectOne(String sqlKey, Object params) {
        T selectOne = null;
        List<T> list = selectList(sqlKey, params);
        if (list!=null) {
            selectOne = list.get(0);
        }
        return selectOne;
    }

    @Override
    public <T> List<T> selectList(String sqlKey, Object params) {
        List<T> list=this.getSqlSession().selectList(sqlKey, params);
        return list;
    }


	}



	UserDaoImpl:

	@Repository("userDao")
	public class UserDaoImpl extends BaseDaoImpl implements UserDao  {

    @Override
    public User selectByPrimaryKey(Integer id) throws Exception{
        return this.selectOne("UserMapper.selectByPrimaryKey",id);
    }

	}


	

7 .添加注解

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




