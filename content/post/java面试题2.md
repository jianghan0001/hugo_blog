+++
tags = ["面试题"]
title = "java面试题2"
draft = false
date = "2017-02-01T10:54:24+02:00"

+++


##### String 和 StringBuffer 和 StringBuilder



String是“字符创常量”，也就是不可改变的对象 , StringBuffer与StringBuilder是字符串变量 ,操作时，实际上是在一个对象上操作的，这样就不会像String一样创建一些而外的对象进行操作

StringBuilder：线程非安全的

StringBuffer：线程安全的


1.如果要操作少量的数据用 = String

2.单线程操作字符串缓冲区 下操作大量数据 = StringBuilder

3.多线程操作字符串缓冲区 下操作大量数据 = StringBuffer


##### ArrayList Vector LinkedList 的区别

ArrayList 和Vector他们底层的实现都是一样的，都是使用数组方式存储数据，此数组元素数大于实际存储的数据以便增加和插入元素，它们都允许直接按序号索引元素，但是插入元素要涉及数组元素移动等内存操作，所以索引数据快而插入数据慢。

Vector中的方法由于添加了synchronized修饰，因此Vector是线程安全的容器，但性能上较ArrayList差，因此已经是Java中的遗留容器。

LinkedList使用双向链表实现存储（将内存中零散的内存单元通过附加的引用关联起来，形成一个可以按序号索引的线性结构，这种链式存储方式与数组的连续存储方式相比，内存的利用率更高），按序号索引数据需要进行前向或后向遍历，但是插入数据时只需要记录本项的前后项即可，所以插入速度较快。

##### Collection 和Collections的区别

java.util.Collection 是一个集合接口。它提供了对集合对象进行基本操作的通用接口方法。

Collection接口在Java 类库中有很多具体的实现。Collection接口的意义是为各种具体的集合提供了最大化的统一操作方式

java.util.Collections 是一个包装类。它包含有各种有关集合操作的静态多态方法。此类不能实例化，就像一个工具类，服务于Java的Collection框架。

##### HashMap和Hashtable的区别

HashMap几乎可以等价于Hashtable，除了HashMap是非synchronized的，并可以接受null(HashMap可以接受为null的键值(key)和值(value)，而Hashtable则不行)。

HashMap是非synchronized，而Hashtable是synchronized，这意味着Hashtable是线程安全的，多个线程可以共享一个Hashtable；而如果没有正确的同步的话，多个线程是不能共享HashMap的。Java 5提供了ConcurrentHashMap，它是HashTable的替代，比HashTable的扩展性更好。

单线程环境下它比HashMap要慢

HashMap不能保证随着时间的推移Map中的元素次序是不变的

