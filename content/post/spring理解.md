+++
tags = ["spring"]
title = "spring的理解"
draft = false
date = "2017-01-11T12:54:24+02:00"

+++


##### 对spring的理解，对于ioc或者aop，他们好在哪里，为什么好


Spring  java企业级应用的开源开发框架。  

Spring主要用来开发Java应用，但是有些扩展是针对构建J2EE平台的web应用。Spring 框架目标是简化Java企业级应用开发，并通过POJO为基础的编程模型促进良好的编程习惯。

Spring框架至今已集成了20多个模块。这些模块主要被分如下图所示的核心容器、数据访问/集成,、Web、AOP（面向切面编程）、工具、消息和测试模块


![](http://i.imgur.com/ZwanfHp.png)



##### 轻量
Spring 是轻量的，基本的版本大约2MB。

##### 控制反转（IOC）

IOC（DI）：通常，每个对象在使用他的合作对象时，自己均要使用像new object（） 这样的语法来完成合作对象的申请工作。你会发现：对象间的耦合度高了。

而IOC的思想是：Spring容器来实现这些相互依赖对象的创建、协调工作。对象只需要关系业务逻辑本身就可以了。从这方面来说，对象如何得到他的协作对象的责任被反转了（IOC、DI）。

DI其实就是IOC的另外一种说法。  
DI是由Martin Fowler 在2004年初的一篇论文中首次提出的。他总结：控制的什么被反转了？就是：获得依赖对象的方式反转了。

Spring所倡导的开发方式就是如此，所有的类都会在spring容器中登记，告诉spring你是个什么东西，你需要什么东西，然后spring会在系统运行到适当的时候，把你要的东西主动给你，同时也把你交给其他需要你的东西。所有的类的创建、销毁都由 spring来控制，也就是说控制对象生存周期的不再是引用它的对象，而是spring。

对于某个具体的对象而言，以前是它控制其他对象，现在是所有对象都被spring控制，所以这叫控制反转。


IoC的一个重点是在系统运行中，动态的向某个对象提供它所需要的其他对象。这一点是通过DI（Dependency Injection，依赖注入）来实现的。

DI ：A需要依赖 Connection才能正常运行，而这个Connection是由spring注入到A中的，依赖注入的名字就这么来的。


DI是如何实现的呢？ Java 1.3之后一个重要特征是反射（reflection），它允许程序在运行的时候动态的生成对象、执行对象的方法、改变对象的属性，spring就是通过反射来实现注入的。




##### 面向切面的编程(AOP)

AOP技术恰恰相反，它利用一种称为"横切"的技术，剖解开封装的对象内部，并将那些影响了多个类的公共行为封装到一个可重用模块，并将其命名为"Aspect"，即切面。

所谓"切面"，简单说就是那些与业务无关，却为业务模块所共同调用的逻辑或责任封装起来，便于减少系统的重复代码，降低模块之间的耦合度，并有利于未来的可操作性和可维护性。

使用"横切"技术，AOP把软件系统分为两个部分：核心关注点和横切关注点。业务处理的主要流程是核心关注点，与之关系不大的部分是横切关注点。

横切关注点的一个特点是，他们经常发生在核心关注点的多处，而各处基本相似，比如权限认证、日志、事物。AOP的作用在于分离系统中的各种关注点，将核心关注点和横切关注点分离开来。


AOP核心概念

1、横切关注点

对哪些方法进行拦截，拦截后怎么处理，这些关注点称之为横切关注点

2、切面（aspect）

类是对物体特征的抽象，切面就是对横切关注点的抽象

3、连接点（joinpoint）

被拦截到的点，因为Spring只支持方法类型的连接点，所以在Spring中连接点指的就是被拦截到的方法，实际上连接点还可以是字段或者构造器

4、切入点（pointcut）

对连接点进行拦截的定义

5、通知（advice）

所谓通知指的就是指拦截到连接点之后要执行的代码，通知分为前置、后置、异常、最终、环绕通知五类

6、目标对象

代理的目标对象

7、织入（weave）

将切面应用到目标对象并导致代理对象创建的过程

8、引入（introduction）

在不修改代码的前提下，引入可以在运行期为类动态地添加一些方法或字段



Spring中AOP代理由Spring的IOC容器负责生成、管理，其依赖关系也由IOC容器负责管理。因此，AOP代理可以直接使用容器中的其它bean实例作为目标，这种关系可由IOC容器的依赖注入提供。Spring创建代理的规则为：

1、默认使用Java动态代理来创建AOP代理，这样就可以为任何接口实例创建代理了

2、当需要代理的类不是代理接口的时候，Spring会切换为使用CGLIB代理，也可强制使用CGLIB

AOP编程其实是很简单的事情，纵观AOP编程，程序员只需要参与三个部分：

1、定义普通业务组件

2、定义切入点，一个切入点可能横切多个业务组件

3、定义增强处理，增强处理就是在AOP框架为普通业务组件织入的处理动作

所以进行AOP编程的关键就是定义切入点和定义增强处理，一旦定义了合适的切入点和增强处理，AOP框架将自动生成AOP代理，即：代理对象的方法=增强处理+被代理对象的方法。


##### 容器

Spring 包含并管理应用中对象的生命周期和配置

##### MVC框架  

MVC 框架是一个全功能的构建 Web 应用程序的 MVC 实现。通过策略接口，MVC 框架变成为高度可配置的，MVC 容纳了大量视图技术，其中包括 JSP、Velocity、Tiles、iText 和 POI。

##### 事务管理

Spring事务管理的实现有许多细节，如果对整个接口框架有个大体了解会非常有利于我们理解事务，下面通过讲解Spring的事务接口来了解Spring实现事务的具体策略。 
Spring事务管理涉及的接口的联系如下

![](http://i.imgur.com/KEWTy7q.png)


Spring并不直接管理事务，而是提供了多种事务管理器，他们将事务管理的职责委托给Hibernate或者JTA等持久化机制所提供的相关平台框架的事务来实现。  

Spring事务管理器的接口是org.springframework.transaction.PlatformTransactionManager，通过这个接口，Spring为各个平台如JDBC、Hibernate等都提供了对应的事务管理器，但是具体的实现就是各个平台自己的事情


具体的事务管理机制对Spring来说是透明的，它并不关心那些，那些是对应各个平台需要关心的，所以Spring事务管理的一个优点就是为不同的事务API提供一致的编程模型




jdbc事务:  

    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource" />
    </bean>

Hibernate事务：

    <bean id="transactionManager" class="org.springframework.orm.hibernate3.HibernateTransactionManager">
    <property name="sessionFactory" ref="sessionFactory" />
    </bean>


##### 异常处理

Spring 提供方便的API把具体技术相关的异常（比如由JDBC，Hibernate or JDO抛出的）转化为一致的unchecked 异常。


可以利用spring提供的@ControllerAdvice和@ExceptionHandler两个注解来做异常的统一处理。前者注解的类，可以作用于所有@Controller标注的Controller，后者注解的方法可以作用于所有@RequestMapping标注的方法抛出的指定类型的异常。










SpringMVC和Spring的加载：
（1）对于Spring和SpringMVC而言，到底谁先加载是关键。两者都是各自维护自己的一个容器。但是SpringMVC的容器要利用一个负责分发请求的DispatcherServlet。而Spring的IOC容器是利用Listern对每个构建的Bean（包括Servlet）都进行生命周期的监听。所以，Spring要快于SpringMVC被加载。
（2）既然这样，首先让Spring加载，利用SpringAOP，把符合PointCut的对象都做动态代理；接着再启动SpringMVC，加载的同时，把动态代理好的@Service对象都@Autowired到相关的对象中。


Spring的优点：

轻量级：相较于EJB容器，Spring采用的IoC容器非常的轻量级，基础版本的Spring框架大约只有2MB。Spring可以让开发者们仅仅使用POJO(Plain Old Java Object，相对于EJB)就能够开发出企业级的应用。这样做的好处是，你不需要使用臃肿庞大的 EJB容器(应用服务器)，你只需要轻量的servlet容器(如Tomcat)。尤其在一些开发当中，很稀缺内存和CPU资源时，采用Spring比EJB无论是开发还是部署应用都更节约资源。  

控制反转(IOC)：Spring使用控制反转技术实现了松耦合。依赖被注入到对象，而不是创建或寻找依赖对象。  

面向切面编程(AOP)： Spring支持面向切面编程，同时把应用的业务逻辑与系统的服务分离开来。  

MVC框架：Spring MVC是一个非常好的MVC框架，可以替换其他web框架诸如Struts。  

集成性：Spring非常容易和其他的流行框架一起集成开发，这些框架包括：ORM框架，logging框架，JEE, Quartz，以及Struts等表现层框架。  

事务管理：Spring强大的事务管理功能，能够处理本地事务(一个数据库)或是全局事务(多个数据，采用JTA)。  

模块分离：Spring框架是由模块构成的。虽然已经有太多的包和类了，但它们都按照模块分好类了，你只需要考虑你会用到的模块，而不用理其他的模块。  

异常处理：由于Java的JDBC，Hibernate等API中有很多方法抛出的是checked exception，而很多开发者并不能很好的处理异常。Spring提供了统一的API将这些checked exception的异常转换成Spring的unchecked exception。

单元测试：Spring写出来的代码非常容易做单元测试，可以采用依赖注射(Dependency Injection)将测试的数据注射到程序中。