
+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "springmvc"
tags = [
  "framework"
,"java"
]
+++

参考链接：[https://linesh.gitbooks.io/spring-mvc-documentation-linesh-translation/content/](https://linesh.gitbooks.io/spring-mvc-documentation-linesh-translation/content/ "springMVC中文文档")

### 简介 

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


	![](http://i.imgur.com/y1Jdjuf.jpg)
	

	DispatcherServlet其实就是个Servlet（它继承自HttpServlet基类），同样也需要在你web应用的web.xml配置文件下声明。
	你需要在web.xml文件中把你希望DispatcherServlet处理的请求映射到对应的URL上去。这就是标准的Java EE Servlet配置；
	下面的代码就展示了对DispatcherServlet和路径映射的声明：


		
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

	
	修改mvc配置文件位置
	
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
	
	配置文件中 会有 对视图的解析，mvc注释的扫描，拦截器interceptors 配置信息。



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



### 控制器(Controller)的实现

	@Controller注解可以认为是被标注类的原型（stereotype），表明了这个类所承担的角色。
	分派器（DispatcherServlet）会扫描所有注解了@Controller的类，检测其中通过@RequestMapping注解配置的方法

加入组件扫描的配置代码来开启框架对 注解控制器 的自动检测

	<context:component-scan base-package="org.springframework.samples.petclinic.web"/>
	


### 使用@RequestMapping注解映射请求路径

	你可以使用@RequestMapping注解来将请求URL，如/appointments等，映射到整个类上或某个特定的处理器方法上。
	一般来说，类级别的注解负责将一个特定（或符合某种模式）的请求路径映射到一个控制器上，
	同时通过方法级别的注解来细化映射，即根据特定的HTTP请求方法（“GET”“POST”方法等）、HTTP请求中是否携带特定参数等条件，
	将请求映射到匹配的方法上。






### @PathVariable   --- 不用追加请求参数，更加简洁,灵活


	在Spring MVC中你可以在方法参数上使用@PathVariable注解，将其与URI模板中的参数绑定起来：
	


	
	@RequestMapping(path="/owners/{ownerId}", method=RequestMethod.GET)   //同名绑定
	public String findOwner(@PathVariable String ownerId, Model model) {

	    Owner owner = ownerService.findOwner(ownerId);
	    model.addAttribute("owner", owner);

	    return "displayOwner";
	}



	@RequestMapping(path="/owners/{ownerId}}", method=RequestMethod.GET)          //别名绑定
	public String findOwner(@PathVariable("ownerId") String theOwner, Model model) {
	    // 具体的方法代码…
	}


	@RequestMapping(path="/owners/{ownerId}/pets/{petId}", method=RequestMethod.GET)               //任意数量变量
	public String findPet(@PathVariable String ownerId, @PathVariable String petId, Model model) {
	    Owner owner = ownerService.findOwner(ownerId);
	    Pet pet = owner.getPet(petId);
	    model.addAttribute("pet", pet);
	    return "displayPet";
	}


	
	@Controller
	@RequestMapping("/owners/{ownerId}")
	public class RelativePathUriTemplateController {                                      //得到类上的变量
	
	    @RequestMapping("/pets/{petId}")                    
	    public void findPet(@PathVariable_ String ownerId, @PathVariable_ String petId, Model model) {
	        // 方法实现体这里忽略
	    }
	
	}




### 正则表达式路径

	@RequestMapping注解支持你在URI模板变量中使用正则表达式。
	
	语法是{varName:regex}，
	
	其中第一部分定义了变量名，第二部分就是你所要应用的正则表达式。
	比如下面的代码样例：

	URL："/spring-web/spring-web-3.0.5.jar

	@RequestMapping("/spring-web/{symbolicName:[a-z-]+}-{version:\\d\\.\\d\\.\\d}{extension:\\.[a-z]+}")
    public void handle(@PathVariable String version, @PathVariable String extension) {
        // 代码部分省略...
    }



### 路径样式的匹配(Path Pattern Comparison)

	
	`** 代表任意的`

	除了URI模板外，@RequestMapping注解还支持Ant风格的路径模式（如/myPath/*.do等）。
	不仅如此，还可以把URI模板变量和Ant风格的glob组合起来使用（比如/owners/*/pets/{petId}这样的用法等）。


	URI模板变量的数目和通配符数量的总和最少的那个路径模板更准确。举个例子，/hotels/{hotel}/*这个路径拥有一个URI变量和一个通配符，
	而/hotels/{hotel}/**这个路径则拥有一个URI变量和两个通配符，因此，我们认为前者是更准确的路径模板。

	如果两个模板的URI模板数量和通配符数量总和一致，则路径更长的那个模板更准确。
	举个例子，/foo/bar*就被认为比/foo/*更准确，因为前者的路径更长。

	如果两个模板的数量和长度均一致，则那个具有更少通配符的模板是更加准确的。比如，/hotels/{hotel}就比/hotels/*更精确。

	
### 请求参数与请求头的值,通过请求参数的存在与否，值来确定是否进入这个处理器

	可以筛选请求参数的条件来缩小请求匹配范围，比如"myParam"、"!myParam"及"myParam=myValue"等。
	前两个条件用于筛选存在/不存在某些请求参数的请求，第三个条件筛选具有特定参数值的请求。
	下面有个例子，展示了如何使用请求参数值的筛选条件：


	@Controller
	@RequestMapping("/owners/{ownerId}")
	public class RelativePathUriTemplateController {
	
	    @RequestMapping(path = "/pets/{petId}", method = RequestMethod.GET, params="myParam=myValue")
	    public void findPet(@PathVariable String ownerId, @PathVariable String petId, Model model) {
	        // 实际实现省略
	    }
	
	}


### 表单的验证（使用Hibernate-validate）及国际化

编写实体类User并加上验证注解


    public class User {
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Date getBirth() {
        return birth;
    }
    public void setBirth(Date birth) {
        this.birth = birth;
    }
    @Override
    public String toString() {
        return "User [id=" + id + ", name=" + name + ", birth=" + birth + "]";
    }    
    private int id;
    @NotEmpty
    private String name;

    @Past
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date birth;
	}


ps:@Past表示时间必须是一个过去值

3.在jsp中使用SpringMVC的form表单

    <form:form action="form/add" method="post" modelAttribute="user">
        id:<form:input path="id"/><form:errors path="id"/><br>
        name:<form:input path="name"/><form:errors path="name"/><br>
        birth:<form:input path="birth"/><form:errors path="birth"/>
        <input type="submit" value="submit">
    </form:form> 

ps:path对应name

4.Controller中代码

    @Controller
	@RequestMapping("/form")
	public class formController {
    @RequestMapping(value="/add",method=RequestMethod.POST)    
    public String add(@Valid User u,BindingResult br){
        if(br.getErrorCount()>0){            
            return "addUser";
        }
        return "showUser";
    }
    
    @RequestMapping(value="/add",method=RequestMethod.GET)
    public String add(Map<String,Object> map){
        map.put("user",new User());
        return "addUser";
    }
	}

ps:

　　1.因为jsp中使用了modelAttribute属性，所以必须在request域中有一个"user".

　　2.@Valid 表示按照在实体上标记的注解验证参数

　　3.返回到原页面错误信息回回显，表单也会回显













