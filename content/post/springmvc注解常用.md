

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


	请求方式的设置 

    @RequestMapping(value="/testMethod",method=RequestMethod.POST)
    public String testMethod(){
        System.out.println("testMethod");
        return "spring";
    }



## 参数的规定与请求头的规定设置 
我们都知道http请求会有着请求参数与请求头消息，那么在springMVC里面，是可以规范这些信息的，首先给一段代码示例：

	     * 代表着这个请求中参数必须包含username参数，而且age不能等于10
     * 而且请求头中，请求的语言为中文，时区为东八区，否则就报错，不允许请求
     * @return
     */
    @RequestMapping(value="testParamsAndHeader",params={"username","age!=10"},headers={"Accept-Language=zh-CN,zh;q=0.8"})
    public String testParamsAndHeader(){
        System.out.println("testParamHeader");
        return "spring";
    }

无论是params，还是headers，都可以包含多个参数，以逗号相隔就行，如果不满足写了的条件，则就会报错，不允许请求资源。其次这两个属性还支持一些简单的表达式：

user  表示请求中，必须包含user的参数
!user 表示请求中，不能包含user的参数
user!=admin    表示请示中，user参数不能为admin
user,age=10    表示请求中必须包含user,age这两个参数，而且age要等于10





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



获取请求中的参数，@RequestParam

在获取类似这种:http://localhost:8080/project/test?user=a&password=2这种请求参数时，就需要用@RequestParam这个注解来获取，代码如下：

/**
     * 使用@RequestParam注解来获取请求参数
     *         value属性       参数名
     *         required       是否非空，默认为true，如果请求中无此参数，则报错，可以设置为false
     *         defaultValue 默认值，当浏览器没有带此参数时，该值会有一个默认值
     * @param username
     * @param password
     * @return
     */
    @RequestMapping(value="/testRequestParam")
    public String testRequestParam(@RequestParam("username") String username,
            @RequestParam(value="password",required=false,defaultValue="我是默认值") String password
            ){
        System.out.println(username);
        System.out.println(password);
        return "spring";
    }


它常用这三个属性，value是参数名，但是如果只写了参数名的话，请求时，就必须带此参数，不然就会报错。  
如果把required属性设置为false，就可以使得该参数不传，还有defaultValue属性，此属性可以当浏览器没有传此参数时，给这个参数一个默认值

## 获取Cookie的信息，@CookieValue
在开发中，有很多情况都会用到Cookie，这里可以使用@CookieValue注解来获取，其使用方法与@RequestParam与@RequestHeader一样，这里就不过多叙述，给出示例代码：

	**
     * 使用@CookieValue注解来获取浏览器传过来的Cookie
     * 它与@RequestHeader与@RequestParam的用法一样，也是有着required与default两个属性来指定是否为空与默认值
     * @param value
     * @return
     */
    @RequestMapping("testCookieValue")
    public String testCookieValue(@CookieValue(value="JSESSIONID",required=true,defaultValue="no") String value){
        System.out.println("CookieValue:"+value);
        return "spring";
    }




## 使用Pojo来获取请求中的大量参数


	/**
     * 使用Pojo对象来传递参数，因为如果一个请求中包含了大量的参数，那么全部用@RequestParam来做肯定太麻烦<br>
     * 这里可以在参数中定义一个实体类，实体类中对应着属性，springMVC就会把从浏览器获取到的参数全部封装到这个对象里面<br>
     * 而且这里面的参数可以为空，而且还支持级联参数（就是指下面User类中的属性还对应了一个Address的类）
     * @param user
     * @return
     */
    @RequestMapping("testPojo")
    public String testPojo(User user){
        System.out.println(user);
        return "spring";
    }


## 表单的验证（使用Hibernate-validate）及国际化

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




## 视图的重定向操作 
上面所说的全部都是视图的转发，而不是重定向，这次我来讲一下重定向是怎么操作的。

只要字符串中以forward或者redirect开头，那么springMVC就会把它解析成关键字，然后进行相应的转发，或者重定向操作，下面给出示例代码：

	/**
     * 测试视图的重定向
     * 只要在字符串中加了foword或者redirect开头，springMVC就会把它解析成关键字，进行相应原转发重定向操作
     * @return
     */
    @RequestMapping("testRedirect")
    public String testRedirect(){
        return "redirect:/spring.jsp";
    }
    /**
     * 测试视图的转发
     * 只要在字符串中加了foword或者redirect开头，springMVC就会把它解析成关键字，进行相应原转发重定向操作
     * @return
     */
    @RequestMapping("testForward")
    public String testForward(){
        return "forward:/spring.jsp";
    }

## 数据的格式化 
form表单向后台处理方法提交一个参数的时候，如果提交一个日期的数据，而后台接收的数据类型则是Date类型，那么springMVC肯定无法将其转换成，因为springMVC不知道你传的数据的格式是怎么样的，所以需要为接收的字段指定日期的格式，使用@DateTimeFormat注解，使用方法如下：

使用前提：需要在springMVC-servlet.xml的配置文件中配置，这个在开发中肯定会配置的，因为它有好多作用，如果不配置，则下面代码无效：


下面是目标方法的代码：

	@RequestMapping("dateFormat")
    public void initBinder(@RequestParam("date") @DateTimeFormat(pattern="yyyy-MM-dd") Date date){
        System.out.println(date);
    }

上面就是在接收的参数前面加了一个@DateTimeFormat注解，注解中写明pattern属性，写上日期的格式，然后在浏览器输入:http://localhost:8080/project/dateFormat?date=19951029，这样springMVC就可以把这个字符串转成Date日期了。

如果是使用Pojo，使用一个对象来接收参数，那么也是一样的，同样是在字段的上方，加上一个@DateTimeFormat注解，如下：

	public class User {
    private Long id;
    private String username;
    private String password;
    private String email;
    private String age;
    private Address address;
    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date birthday;
    ..省略get,set方法
	}


## 数字的格式化

除了日期的格式化，我们可能还会遇到数字的格式化，比如会计人员作账时，数字喜欢这样写 1,234,567.8 因为这样简单明了，但是如果由java直接来解析的话，肯定是不行的，因为这根本就不是一个Float类型的数据，肯定是要报错的，那么要如何呢？我们可以使用@NumberFormat()注解，这个注解的使用方式，和使用前提和8.1章节，日期的格式化是一样的，请先查看8.1章节，再看本章。

和之前一样，是肯定要配置的，不过这里就不详细说明了，下面给出执行方法的代码：

	@RequestMapping("numFormat")
    public String numFormat(@RequestParam("num") @NumberFormat(pattern="#,###,###.#") Float f){
        System.out.println(f);
        return "spring";
    }

其使用方法，其实是和@DateTimeFormat是一样的，但是这里的参数有必要说明一样，”#“是代表数字，那么这个时候，就可以对其进行解析了。如果你传入的是一个正确的Float类型的数据，那么它会被正确的接收这个数字，如果不是一个Float类型的数据，那么springMVC会尝试使用@NumberFoamat注解的参数来尝试解析。

如输入的是http://locathost:8080/project?num=123，那么springMVC会解析成123.0，如果是http://locathost:8080/project?num=123.1，则会正常显示成123.1，那如果是http://locathost:8080/project?num=1,234,567.8这种特殊的写法，则也会正确的解析成1234567.8 



## JSR303的验证类型 
通过上面的例子我们知道可以使用注解来验证数据类型，但是具体可以使用哪些注解呢，下面给出说明：

@Null    　　　　　　　　　　　　 被注释的元素必须为 null
@NotNull    　　　　　　　　　　 被注释的元素必须不为 null
@AssertTrue    　　　　　　　　  被注释的元素必须为 true
@AssertFalse   　　　　　　　　  被注释的元素必须为 false
@Min(value)    　　　　　　　　  被注释的元素必须是一个数字，其值必须大于等于指定的最小值
@Max(value)       　　　　　　   被注释的元素必须是一个数字，其值必须小于等于指定的最大值
@DecimalMin(value)    　　　　  被注释的元素必须是一个数字，其值必须大于等于指定的最小值
@DecimalMax(value)    　　　　  被注释的元素必须是一个数字，其值必须小于等于指定的最大值
@Size(max, min)        　　　　 被注释的元素的大小必须在指定的范围内
@Digits (integer, fraction)    被注释的元素必须是一个数字，其值必须在可接受的范围内
@Past    　　　　　　　　　　　　　被注释的元素必须是一个过去的日期
@Future    　　　　　　　　　　　　被注释的元素必须是一个将来的日期
@Pattern(value)    　　　　　　　被注释的元素必须符合指定的正则表达式
//-----------------下面是hibernate-valitor新增加的
@Email    　　　　　　　　　　　　 被注释的元素必须是电子邮箱地址
@Length    　　　　　　　　　　　　被注释的字符串的大小必须在指定的范围内
@NotEmpty    　　　　　　　　　　　被注释的字符串的必须非空
@Range    　　　　　　　　　　　　　被注释的元素必须在合适的范围内



## 传递json类型的数据 
而在springMVC中，使用json非常的简单，但是首先需要引进其它的一些jar包，那就是jackson，这是一个解析json的jar包，然后就可以直接使用了，下面给出代码示例：

	/**
     * 打印json字符串
     * @return
     */
    @ResponseBody
    @RequestMapping("testjson")
    public List testJson(){
        List list = new ArrayList();
        list.add("good");
        list.add("12");
        list.add("dgdgd");
        list.add("99999999999");
        return list;
    }

如上如示，只要在执行方法的上面加上@ResponseBody注解，然后定义目标方法的返回值，其返回值可以是任意集合，也可以是任意对象，然后springMVC会自动将其转换成json




## 文件上传 

springMVC也封装了文件上传，变的极其简单，但是需要引入common-io.jar与common.upload.jar包，然后需要在spinrgMVC-serlvet.xml中作如下的配置:

	<!-- 配置nultipartresolver,注意：id名必须这样写，不然会报错 -->
    <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="defaultEncoding" value="UTF-8"></property>
        <property name="maxInMemorySize" value="10240000"></property>
    </bean>


controller中

	@RequestMapping("testFileUpload")
    public String testFileUpload(@RequestParam(value="desc",required=false) String desc,
                @RequestParam(value="file",required=false) MultipartFile files[]) throws IOException{
        for(MultipartFile file : files){
            System.out.println(desc);
            System.out.println(file.getOriginalFilename());//得到文件的原始名字
            System.out.println(file.getName());//得到文件的字段的名字”file
            InputStream in = file.getInputStream();
            OutputStream out = new FileOutputStream("d:/"+file.getOriginalFilename());
            int len=0;
            byte[] buf =new byte[1024];
            while((len=in.read(buf))!=-1){
                out.write(buf);
                out.flush();
            }
            out.close();
            in.close();
        }
        return "spring";
    }





## 拦截器


拦截器 
1.第一个拦截器

编写拦截器极其简单，只要编写一个类，实现HandlerInterceptor的方法，然后在springMVC的配置文件中配置这个类，就可以使用这个拦截器了。

首先给出配置文件的写法：

  <!-- 配置自定义的拦截器 -->
    	<mvc:interceptors>
    <!-- 这个bean就是自定义的一个类，拦截器 -->
        <bean class="zxj.intercepter.FirstInterceptor"></bean>
    </mvc:interceptors>

然后再来写FirstInterceptor这个拦截器，代码如下：

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.web.servlet.HandlerInterceptor;
	import org.springframework.web.servlet.ModelAndView;
	/**
	* 写一个拦截器，需要实现HandlerInterceptor接口
	* @author jie
	 *
	*/
	public class FirstInterceptor implements HandlerInterceptor {

    /**
     * 当目标方法执行之前，执行此方法，如果返回false，则不会执行目标方法，同样的，后面的拦截器也不会起作用
     * 可以用来做权限，日志等
     */
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception {
        System.out.println("这个方法会最先执行..");
        return true;
    }

    /**
     * 执行目标方法之后调用，但是在渲染视图之前，就是转向jsp页面之前
     * 可以对请求域中的属性，或者视图进行修改
     */
    public void postHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        System.out.println("执行目标方法之后调用，但是在渲染视图之前，就是转向jsp页面之前");
    }

    /**
     * 在渲染视图之后被调用
     * 释放资源
     */
    public void afterCompletion(HttpServletRequest request,
            HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        System.out.println("在渲染视图之后被调用");
    }

}



然后在每个执行方法调用之前，都会先进拦截器，这就是一个简单的拦截器的写法了。

2.拦截器的指定范围

在使用拦截器时候，并不一定要对所有的目标方法都进行拦截，所以我们可以只对指定的方法进行拦截，这就需要更改配置文件了，下面给出配置文件的写法：

<!-- 配置自定义的拦截器 -->
    <mvc:interceptors>
    <!-- 这个bean就是自定义的一个类，拦截器 -->
        <bean class="zxj.intercepter.FirstInterceptor"></bean>
        <!-- 这个配置可以配置拦截器作用（不作用）的路径,不起作用的用<mvc:exclude-mapping path=""/> -->
        <mvc:interceptor>
            <!-- 这个path就是起作用的路径，可以使用通配符 -->
            <mvc:mapping path="/test*"/>
            <bean class="zxj.intercepter.SecondInterceptor"></bean>
        </mvc:interceptor>
    </mvc:interceptors>


只需要在中配置一个，然后指定其路径，就可以了，这个路径可以指定一个URL，也可以使用通配符。

3.拦截器的使用顺序 
当同时定义了多个拦截器的时候，那么它的使用顺序是怎么样的呢？

preHandle是按配置文件中的顺序执行的

postHandle是按配置文件中的倒序执行的

afterCompletion是按配置文件中的倒序执行的
