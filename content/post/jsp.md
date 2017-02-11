+++
tags = ["java"]
title = "jsp"
draft = false
date = "2017-02-09T22:54:24+02:00"

+++



jsp的九大内置对象，三大指令，七大动作的具体功能

	JSP九大内置对象:
	pageContext ：只对当前jsp页面有效，里面封装了基本的request和session的对象
	Request ：对当前请求进行封装
	Session ：浏览器会话对象，浏览器范围内有效
	Application ：应用程序对象，对整个web工程都有效
	Out ：页面打印对象，在jsp页面打印字符串
	Response ：返回服务器端信息给用户
	Config ：单个servlet的配置对象，相当于servletConfig对象
	Page ：当前页面对象，也就是this
	Exception ：错误页面的exception对象，如果指定的是错误页面，这个就是异常对象

三大指令：

	Page ：指令是针对当前页面的指令
	Include ：用于指定如何包含另一个页面
	Taglib ：用于定义和指定自定义标签

七大动作：

	Forward，执行页面跳转，将请求的处理转发到另一个页面
	Param ：用于传递参数
	Include ：用于动态引入一个jsp页面
	Plugin ：用于下载javaBean或applet到客户端执行
	useBean ：使用javaBean
	setProperty ：修改javaBean实例的属性值
	getProperty ：获取javaBean实例的属性值