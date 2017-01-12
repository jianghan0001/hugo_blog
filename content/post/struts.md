+++
tags = ["struts"]
title = "struts原理"
draft = false
date = "2017-01-12T12:54:24+02:00"

+++



![](http://i.imgur.com/AlMdoXb.jpg)


##### 流程

1、客户端初始化一个指向Servlet容器（例如Tomcat）的请求

2、这个请求经过一系列的过滤器（Filter）（这些过滤器中有一个叫做ActionContextCleanUp的可选过滤器，这个过滤器对于Struts2和其他框架的集成很有帮助，例如：SiteMesh Plugin） 

3、接着FilterDispatcher被调用，FilterDispatcher询问ActionMapper来决定这个请是否需要调用某个Action 
   FilterDispatcher是控制器的核心，就是mvc中c控制层的核心。下面粗略的分析下我理解的FilterDispatcher工作流程和原理：FilterDispatcher进行初始化并启用核心doFilter


4、如果ActionMapper决定需要调用某个Action，FilterDispatcher把请求的处理交给ActionProxy 

5、ActionProxy通过ConfigurationManager询问框架的配置文件，找到需要调用的Action类 ,这里，我们一般是从struts.xml配置中读取。

6、ActionProxy创建一个ActionInvocation的实例。

7、ActionInvocation实例使用命名模式来调用，在调用Action的过程前后，涉及到相关拦截器（Intercepter）的调用。


 8、一旦Action执行完毕，ActionInvocation负责根据struts.xml中的配置找到对应的返回结果。返回结果通常是（但不总是，也可能是另外的一个Action链）一个需要被表示的JSP或者FreeMarker的模版。在表示的过程中可以使用Struts2 框架中继承的标签。在这个过程中需要涉及到ActionMapper





##### 百度百科：

应用流程注解  

当Web容器收到请求（HttpServletReques  
t）它将请求传递给一个标准的的过滤链包括（ActionContextCleanUp）过滤器。

经过Other filters(SiteMesh ,etc)，需要调用FilterDispatcher核心控制器，然后它调用ActionMapper确定请求哪个Action，

ActionMapper返回一个收集Action详细信息的ActionMaping对象。
FilterDispatcher将控制权委派给ActionProxy,ActionProxy调用配置管理器(ConfigurationManager) 从配置文件中读取配置信息(struts.xml)，然后创建ActionInvocation对象。

ActionInvocation在调用Action之前会依次的调用所用配置拦截器（Interceptor N）一旦执行结果返回结果字符串ActionInvocation负责查找结果字符串对应的(Result）然后执行这个Result Result会调用一些模版（JSP）来呈现页面。

拦截器(Interceptor N)会再被执行（顺序和Action执行之前相反）最后响应(HttpServletResponse)被返回在web.xml中配置的那些过滤器和（核心控制器）（FilterDispatcher）。