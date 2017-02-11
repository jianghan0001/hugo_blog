



+++
tags = ["java"]
title = "两种include区别"
draft = false
date = "2017-02-09T22:54:24+02:00"

+++



动态 INCLUDE 用 jsp:include 动作实现 <jsp:include page="included.jsp" flush="true" /> 它总是会检查所含文件中的变化 , 适合用于包含动态页面 , 并且可以带参数。各个文件分别先编译，然后组合成一个文件。

静态 INCLUDE 用 include 伪码实现 , 定不会检查所含文件的变化 , 适用于包含静态页面 <%@ include file="included.htm" %> 。先将文件的代码被原封不动地加入到了主页面从而合成一个文件，然后再进行翻译，此时不允许有相同的变量。 

以下是对 include 两种用法的区别 ， 主要有两个方面的不同 ;
    

一 : 执行时间上 :
    <%@ include file="relativeURI"%> 是在翻译阶段执行
    <jsp:include page="relativeURI" flush="true" /> 在请求处理阶段执行 .
    二 : 引入内容的不同 :
    <%@ include file="relativeURI"%>
    引入静态文本 (html,jsp), 在 JSP 页面被转化成 servlet 之前和它融和到一起 .
    <jsp:include page="relativeURI" flush="true" /> 引入执行页面或 servlet 所生成的应答文本