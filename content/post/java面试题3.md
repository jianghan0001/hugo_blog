+++
tags = ["面试题"]
title = "java面试题3"
draft = false
date = "2017-02-01T10:58:24+02:00"

+++


##### 集合

![](http://i.imgur.com/MMylCjl.jpg)



![](http://i.imgur.com/ejZsqiz.jpg)




##### swtich是否能作用在byte上，是否能作用在long上，是否能作用在String


switch可作用于char byte short int
switch可作用于char byte short int对应的包装类
switch不可作用于long double float boolean，包括他们的包装类


switch中可以是字符串类型,String(jdk1.7之后才可以作用在string上)


##### char型变量中能不能存贮一个中文汉字?为什么?

char型变量是用来存储Unicode编码的字符的，unicode编码字符集中包含了汉字，
 
所以，char型变量中当然可以存储汉字啦。不过，如果某个特殊的汉字没有被包含在

unicode编码字符集中，那么，这个char型变量中就不能存储这个特殊汉字。补充

说明：unicode编码占用两个字节，所以，char类型的变量也是占用两个字节。


##### 多线程有几种实现方法,都是什么?哪一种方式比较优秀

一是直接继承Thread类，二是实现Runnable接口,使用Calable和Future创建具备返回值的线程。



Java 5以前实现多线程有两种实现方法：一种是继承Thread类；另一种是实现Runnable接口。两种方式都要通过重写run()方法来定义线程的行为，推荐使用后者，因为Java中的继承是单继承，一个类有一个父类，如果继承了Thread类就无法再继承其他类了，显然使用Runnable接口更为灵活


Java 5以后创建线程还有第三种方式：实现Callable接口，该接口中的call方法可以在线程执行结束时产生一个返回值。


利用扩展Thread类创建的多个线程，虽然执行的是相同的代码，但彼此相互独立，且各自拥有自己的资源，互不干扰


实现Runnable接口相对于扩展Thread类来说，具有无可比拟的优势。这种方式不仅有利于程序的健壮性，使代码能够被多个线程共享，而且代码和数据资源相对独立，从而特别适合多个具有相同代码的线程去处理同一资源的情况。这样一来，线程、代码和数据资源三者有效分离，很好地体现了面向对象程序设计的思想。因此，几乎所有的多线程程序都是通过实现Runnable接口的方式来完成的。


继承类是一个线程，实现Runnable是变成一个runnable，任务。


用Runnable与Callable接口的方式创建多线程的特点：

线程类只是实现了Runnable接口或Callable接口，还可以继承其它类。
在这种方式下，多个线程可以共享一个target对象，所以非常适合多个线程来处理同一份资源情况。
如果需要访问当前线程，需要使用Thread.currentThread方法。
Callable接口与Runnable接口相比，只是Callable接口可以返回值而已。
用Thread类的方式创建多线程的特点：

因为线程已经继承Thread类，所以不可以再继承其它类。
如果需要访问当前线程，直接使用this即可。




##### java中有几种类型的流？JDK为每种类型的流提供了一些抽象类以供继承，请说出他们分别是哪些类？


Java中的流分为两种，一种是字节流，另一种是字符流，分别由四个抽象类来表示（每种流包括输入和输出两种所以一共四个）:InputStream，OutputStream，Reader，Writer。Java中其他多种多样变化的流均是由它们派生出来的.








