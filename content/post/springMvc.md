+++
tags = ["spring"]
title = "springMVC上"
draft = false
date = "2017-01-11T12:54:24+02:00"

+++



Spring MVC属于SpringFrameWork的后续产品，已经融合在Spring Web Flow里面

spring 框架提供了构建 Web 应用程序的全功能 MVC 模块。使用 Spring 可插入的 MVC 架构，可以选择是使用内置的 Spring Web 框架还是 Struts 这样的 Web 框架。通过策略接口，Spring 框架是高度可配置的，而且包含多种视图技术，例如 JavaServer Pages（JSP）技术、Velocity、Tiles、iText 和 POI。Spring MVC 框架并不知道使用的视图，所以不会强迫您只使用 JSP 技术



Spring MVC框架是一个MVC框架，通过实现Model-View-Controller模式来很好地将数据、业务与展现进行分离。

Spring MVC的设计是围绕DispatcherServlet展开的，DispatcherServlet负责将请求派发到特定的handler。通过可配置的hander mappings、view resolution、locale以及theme resolution来处理请求并且转到对应的视图。Spring MVC请求处理的整体流程如图：


![](http://i.imgur.com/D7Tka64.png)




Spring MVC环境搭建, 首先建立一个Java Web的工程，我建立的工程名字叫做SpringMVC，要搭建一个基础功能的Spring MVC环境，必须引入的jar包是beans、context、core、expression、web、webmvc以及commons-logging。




    <servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      <param-name>contextConfigLocation</param-name>
      <param-value>classpath:springmvc-servlet.xml</param-value>
      </init-param>
      <load-on-startup>1</load-on-startup> 
    </servlet>
     
    <servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
    </servlet-mapping>


servlet是必须的，url-pattern用于开发者选择哪些路径是需要让Spring MVC来处理的。接着在classpath下按照我们约定的名字springmvc-servlet.xml写一个xml文件


	<context:annotation-config />    
    <context:component-scan base-package="com.xrq.controller"/>
 
    <!-- 配置视图解析器 -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">  
        <!-- WebRoot到一指定文件夹文件路径 --> 
        <property name="prefix" value="/" />  
        <!-- 视图名称后缀  --> 
        <property name="suffix" value=".jsp" />  
    </bean> 




##### Model


1、Model本身是一个接口，其实现类为ExtendedModelMap，除了使用Model之外还可以使用ModelAndView、ModelMap这些，不过要是没有特殊需求，使用Model比较简单，我个人也比较喜欢使用Model

2、Model的生命周期是Request，也就是说要通过Model传值只能使用转发而不能使用重定向

3、为什么要使用Model而不是用Request，最主要的原因就是减少代码的侵入性或者说代码的耦合度也行。因为Model是Spring的组件，Request是J2EE的组件，使用Model而不去使用Request可以减少对J2EE的依赖，也便于调试 



##### 拦截器（Interceptor）

SpringMVC中的拦截器相当于J2EE中的过滤器，是非常重要和相当有用的，它的主要作用就是拦截用户的请求并进行相应的处理的，比如通过它来进行权限验证，或者是来判断用户是否登陆。

在SpringMVC中使用拦截器的方法比较简单，首先实现HandlerInterceptor接口，实现afterCompletion、postHandle、preHandle三个抽象方法.


1、afterCompletion：在整个视图渲染完毕之后执行方法里面的内容，主要用于释放一些资源

2、postHandle：在Controller执行之后，视图渲染之前执行方法里面的内容，也就是说postHandle方法可以对Model进行操作

3、preHandle：在Controller执行之前，执行方法里面的内容，注意该方法是有返回值的，当方法返回false时整个请求就结束了


在springmvc-servlet.xml里面增加拦截器的配置：

    <!-- 配置拦截器 -->
    <mvc:interceptors>
       <mvc:interceptor>
	       <mvc:mapping path="/test" />
	    <bean class="com.xrq.interceptor.TestInterceptor2" />
	    </mvc:interceptor>
	    <mvc:interceptor>
	    <mvc:mapping path="/test" />
	    <bean class="com.xrq.interceptor.TestInterceptor1" />
	    </mvc:interceptor>
    </mvc:interceptors>


两个拦截器执行结果如下

    TestInterceptor2.preHandle()
    TestInterceptor1.preHandle()
    TestInterceptor1.postHandle()
    TestInterceptor2.postHandle()
    TestInterceptor1.afterCompletion()
    TestInterceptor2.afterCompletion()


也许有些朋友对这个执行结果不是很理解，我其实是懂的，但确实一下子也说不清楚。

如果不是很理解的朋友，可以去看一下Java设计模式里面的责任链模式，拦截器的这种调用方法实际上是一种链式的调用法，TestInterceptor2调用TestInterceptor1，TestInterceptor1方法走了才会回到TestInterceptor2的方法里面




##### POST中文乱码解决方案

spring Web MVC框架提供了org.springframework.web.filter.CharacterEncodingFilter用于解决POST方式造成的中文乱码问题，具体配置如下：


    <filter>  
    <filter-name>CharacterEncodingFilter</filter-name>  
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>  
    <init-param>  
    <param-name>encoding</param-name>  
    <param-value>utf-8</param-value>  
    </init-param>  
    </filter>  
    <filter-mapping>  
    <filter-name>CharacterEncodingFilter</filter-name>  
    <url-pattern>/*</url-pattern>  
    </filter-mapping>