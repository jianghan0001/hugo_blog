
+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "springmvc简介"
tags = [
  "springmvc"
]
+++


## 简介 

Spring的模型-视图-控制器（MVC）框架是围绕一个DispatcherServlet来设计的，这个Servlet会把请求分发给各个处理器，

并支持可配置的处理器映射、视图渲染、本地化、时区与主题渲染等，甚至还能支持文件上传。

处理器是你的应用中注解了@Controller和@RequestMapping的类和方法，Spring为处理器方法提供了极其多样灵活的配置。

Spring 3.0以后提供了@Controller注解机制、@PathVariable注解以及一些其他的特性.


Spring的视图解析也是设计得异常灵活。控制器一般负责准备一个Map模型、填充数据、返回一个合适的视图名等，

同时它也可以直接将数据写到响应流中。视图名的解析高度灵活，支持多种配置.


模型（MVC中的M，model）其实是一个Map类型的接口，彻底地把数据从视图技术中抽象分离了出来。

你可以与基于模板的渲染技术直接整合，如JSP、Velocity和Freemarker等，或者你还可以直接生成XML、JSON、Atom以及其他多种类型的内容。

Map模型会简单地被转换成合适的格式，比如JSP的请求属性（attribute），一个Velocity模板的模型等。


### DispatcherServlet


Spring MVC框架，与其他很多web的MVC框架一样：请求驱动；所有设计都围绕着一个中央Servlet来展开，

它负责把所有请求分发到控制器；同时提供其他web应用开发所需要的功能。不过Spring的中央处理器，DispatcherServlet，能做的比这更多。

它与Spring IoC容器做到了无缝集成，这意味着，Spring提供的任何特性，在Spring MVC中你都可以使用。

	

下图展示了Spring Web MVC的DispatcherServlet处理请求的工作流。熟悉设计模式的朋友会发现，

DispatcherServlet应用的其实就是一个“前端控制器”的设计模式（其他很多优秀的web框架也都使用了这个设计模式）。


	


DispatcherServlet其实就是个Servlet（它继承自HttpServlet基类），同样也需要在你web应用的web.xml配置文件下声明。

你需要在web.xml文件中把你希望DispatcherServlet处理的请求映射到对应的URL上去。这就是标准的Java EE Servlet配置；

下面的代码就展示了对DispatcherServlet和路径映射的声明（ web.xml中 ）：


		
	    <servlet>
	        <servlet-name>example</servlet-name>
	        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
	        <load-on-startup>1</load-on-startup>
	    </servlet>
	
	    <servlet-mapping>
	        <servlet-name>example</servlet-name>
	        <url-pattern>/example/*</url-pattern>
	    </servlet-mapping>
		



上面的例子中，所有路径以/example开头的请求都会被名字为example的DispatcherServlet处理。



DispatcherServlet的初始化过程中，Spring MVC会在你web应用的WEB-INF目录下查找一个名为[servlet-name]-servlet.xml的配置文件，

并创建其中所定义的bean。



以上的Servlet配置文件，你还需要在应用中的/WEB-INF/路径下创建一个example-servlet.xml文件，

	

## 修改mvc配置文件位置
	

在配置DispatcherServlet时指定mvc配置文件的位置


eg:

		<servlet>  
		    <servlet-name>example</servlet-name>  
		    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>  
	
			    <init-param>  
			        <param-name>contextConfigLocation</param-name>  
			        <param-value>classpath:/applicationContext.xml</param-value>  
			    </init-param>  

		</servlet>  
		<servlet-mapping>  
		    <servlet-name>example</servlet-name>  
		    <url-pattern>/</url-pattern>  
		</servlet-mapping>  
	



以上配置为： 创建名为example的DispatcherServlet，配置文件为/applicationContext.xml ,拦截 / 所有请求.
	

对注释进行解析

	 <context:component-scan base-package="zxj">

配置文件中 会有 对视图的解析，mvc注释的扫描，拦截器interceptors 配置信息。

	<!-- 视图分解解析器 -->
    <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <!-- 这是前缀 -->
        <property name="prefix" value="/"></property>
        <!-- 这是后缀 -->
        <property name="suffix" value=".jsp"></property>
        <!-- 在spring的控制器中，返回的是一个字符串，那么请求的路径则是，前缀+返回字符串+后缀 -->
    </bean>




### 其它配置文件位置


其他配置文件，指的是对datasource的配置、persistence层的配置、service层的配置信息等。要加载其他配置文件，

需要在web.xml配置文件中加入一个ContextLoaderListener监听器来配置.

ContextLoaderListener只监听初始化除 mvc 相关配置之外的bean.


	<listener>  
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
	</listener>  

	<context-param>  
	    <param-name>contextConfigLocation</param-name>  
	    <param-value>  
	        classpath:config/service-context.xml  
	        classpath:config/persistence-context.xml  
	        classpath:config/datasource-context.xml  
	        </param-value>  
	</context-param> 









