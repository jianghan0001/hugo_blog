
+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "maven"
tags = [
  "framework"
,"java"
]
+++



### maven 创建web应用 

	1. 当然可以用工具直接创建(idea,eclipse).

	2. 
	
	mvn archetype:generate -DgroupId=com.yiibai -DartifactId=CounterWebApp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false


  新的Web项目命名为 “CounterWebApp”，以及一些标准的 web 目录结构也会自动创建。


### 项目目录布局


		.|____CounterWebApp
		||____pom.xml
		||____src
		|||____main
		||||____resources
		||||____webapp
		|||||____index.jsp
		|||||____WEB-INF
		||||||____web.xml


	pom.xml 进行包管理 .




### pom.xml 


	在Maven中，Web项目的设置都通过这个单一的pom.xml文件配置。
	
	添加项目依赖 - Spring 和 JUnit
	添加插件来配置项目


	pom.xml示例

	
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
	
	
	  </dependencies>
	  <build>
	    <finalName>bcode</finalName>
	                                           
	    <plugins>
	      <plugin>      
	        <groupId>org.apache.tomcat.maven</groupId>
	        <artifactId>tomcat7-maven-plugin</artifactId>         //maven 嵌入tomcat 插件，可在根目录执行mvn tomcat7:run 来执行项目
	        <version>2.1</version>
	        <configuration>
	          <port>8080</port>
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



### 清理

	mvn clean

	在基于Maven的项目中，很多缓存输出在“target”文件夹中。如果想建立项目部署，必须确保清理所有缓存的输出，从面能够随时获得最新的部署。

	当“mvn clean”执行，在“target”文件夹中的一切都将被删除。



### 打包


	mvn package  

	会在target文件夹生成可以直接放到tomcat中的文件夹和一个war包



	通常先清理，再打包， mvn clean package




### maven 嵌入 tomcat插件使用


		在pom.xml中<plugins>添加如下配置信息，配置tomcat7插件


	 	<plugin>      
	        <groupId>org.apache.tomcat.maven</groupId>
	        <artifactId>tomcat7-maven-plugin</artifactId>        
	        <version>2.1</version>
	        <configuration>
	          <port>8080</port>
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


		   在项目根目录下执行mvn clean package 

			mvn tomcat7:run


			便可部署并启动tomcat项目，若在idea中配置configuration.

			实际上是部署的 mvn package 生成的war包

			真正服务器上通常不使用maven的tomcat插件来开启服务，而是使用真的tomcat服务器，将生成文件夹或war包进行路径配置，部署项目。




### Tomcat 与 maven 认证

	添加具有角色管理器GUI和管理脚本的用户。
	
	%TOMCAT7_PATH%/conf/tomcat-users.xml


	<?xml version='1.0' encoding='utf-8'?>
	<tomcat-users>
	
		<role rolename="manager-gui"/>
		<role rolename="manager-script"/>
		<user username="admin" password="password" roles="manager-gui,manager-script" />
	
	</tomcat-users>



	Maven 认证

	添加在上面Maven 设置文件的 Tomcat 用户，是之后Maven使用此用户来登录Tomcat服务器。
	
	%MAVEN_PATH%/conf/settings.xml
	
	<?xml version="1.0" encoding="UTF-8"?>
	<settings ...>
		<servers>
		   
			<server>
				<id>TomcatServer</id>
				<username>admin</username>
				<password>password</password>
			</server>
	
		</servers>
	</settings>
