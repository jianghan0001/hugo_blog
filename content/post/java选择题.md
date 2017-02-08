+++
tags = ["面试题,java"]
title = "java选择题"
draft = false
date = "2017-02-08T10:58:24+02:00"

+++


如下代码：

	boolean bool = true;
	if(bool = false) {
	System.out.println("a");
	} else if (bool) {
	System.out.println("b");
	} else if (!bool) {
	System.out.println("c");
	} else {
	System.out.println("d");
	}
输出结果是什么?  
A. a  
B. b  
C. c  
D. d   
E. 编译失败  
答案：C


下数组的定义，哪三条是正确的? 
  
	A. public int a []  
	B. static int [] a
	C. public [] int a
	D. private int a [3]
	E. private int [3] a []
	F. public final int [] a

答案：A,B,F


在接口中以下哪条定义是正确的? (两个答案)    

	A. void methoda();
	B. public double methoda();
	C. public final double methoda();
	D. static void methoda(double d1);
	E. protected void methoda(double d1);
答案：A，B


如下代码：

	public void test(int x) {
	int odd = x%2;
	if (odd) {
	System.out.println("odd);
	} else {
	System.out.println("even");
	}
	}

哪个描述正确?


	A. 编译失败.
	B. "odd" 永远被输出.
	C. "even" 永远被输出
	D. "odd" 输出x的值,
	E. "even" 输出x的值
答案：A


以下哪四个能使用throw抛出?

	A. Error
	B. Event
	C. Object
	D. Throwable
	E. Exception
	F. RuntimeException

答案：A,D,E,F


