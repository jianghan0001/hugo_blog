+++
tags = ["springmvc","mybatis"]
title = "springmvc相关链接"
draft = false
date = "2017-01-11T12:54:24+02:00"

+++



springmvc深入解析：
[http://blog.csdn.net/scholar_man/article/details/48051165](http://blog.csdn.net/scholar_man/article/details/48051165)


spring+springmvc+mybatis:

[http://www.importnew.com/22880.html](http://www.importnew.com/20215.html)


ssm+MySQL 整合：

[http://www.importnew.com/20215.html](http://www.importnew.com/20215.html)


（1）<context:component-scan>扫描和@Component相关的注解。其中包括@Controller，@Service，@Repository等，这些都是从@Component中继承而来的；并且完成对应注解内容的注入，也就是说这个标签它涵盖了下面这个标签的功能。 
 
（2）<context:annotation-config> 扫描和@Autowired相关、相似的注解。其中包括@Required，@Autowired等等，这些标签有些是JSR规范的，所以Java原生的辅助注解。  

（3）<mvn:annotation-driven>扫描Java配置MVC的部分，官网的内容指示的是：@EnableWebMvc，@Configuration修饰的一个类，等同于编程式声明。然后扫这个类就知道了mvc的配置，如果用了xml根本不需要这样弄。   

这里强调一下如果使用SpringMVC，就用。因为Ioc是顶端依赖驱动的。也就是说，扫描@Controller是顶端，一直往下找@Autowried。如果没有@Controller，就找@Service作为顶端，一直网下载@Autowried。如果没有使用SpringMVC，那么就用。



SpringMVC和Spring的加载：
（1）对于Spring和SpringMVC而言，到底谁先加载是关键。两者都是各自维护自己的一个容器。但是SpringMVC的容器要利用一个负责分发请求的DispatcherServlet。而Spring的IOC容器是利用Listern对每个构建的Bean（包括Servlet）都进行生命周期的监听。所以，Spring要快于SpringMVC被加载。
（2）既然这样，首先让Spring加载，利用SpringAOP，把符合PointCut的对象都做动态代理；接着再启动SpringMVC，加载的同时，把动态代理好的@Service对象都@Autowired到相关的对象中。


