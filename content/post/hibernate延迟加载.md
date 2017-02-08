+++
tags = ["hibernate"]
title = "hibernate延迟加载"
draft = false
date = "2017-02-08T10:58:24+02:00"

+++


hibernate中lazy的使用

lazy，延迟加载

Lazy的有效期：只有在session打开的时候才有效；session关闭后lazy就没效了。

lazy策略可以用在：

* <class>标签上：可以取值true/false
* <property>标签上，可以取值true/false，这个特性需要类增强
* <set>/<list>等集合上，可以取值为true/false/extra
* <one-to-one>/<many-to-one>等标签上，可以取值false/proxy/no-proxy


6.1 get和load的区别：

* get不支持延迟加载，而load支持。
* 当查询特定的数据库中不存在的数据时，get会返回null，而load则抛出异常。


6.2 类(Class)的延迟加载：

* 设置<class>标签中的lazy="true",或是保持默认（即不配置lazy属性)
* 如果lazy的属性值为true，那么在使用load方法加载数据时，只有确实用到数据的时候才会发出sql语句；这样有可能减少系统的开销。
* //不会发出查询sql
       System.out.println("group id=" + group.getId());
这里有一个问题，为什么加载主键的时候不需要发出sql语句。

6.3 集合(collection)的延迟加载：可以取值true，false，extra


* 保持集合上的lazy的默认值，此时的效果和lazy="extra"是基本一样的。
   * 设置集合上的lazy=extra,此时的效果和lazy属性的默认值是基本一样的。但是推荐使用这个属性值，因为在统计时这种情况显得比较智能。当然延迟是有效果的。
* 设置集合上的lazy=false
true:默认取值，它的意思是只有在调用这个集合获取里面的元素对象时，才发出查询语句，加载其集合元素的数据
false:取消懒加载特性，即在加载对象的同时，就发出第二条查询语句加载其关联集合的数据
extra:一种比较聪明的懒加载策略，即调用集合的size/contains等方法的时候，hibernate
并不会去加载整个集合的数据，而是发出一条聪明的SQL语句，以便获得需要的值，只有在真正需要用到这些集合元素对象数据的时候，才去发出查询语句加载所有对象的数据


6.4 Hibernate单端关联懒加载策略：即在<one-to-one>/<many-to-one>标签上可以配置
懒加载策略。可以取值为：false/proxy/no-proxy

false:取消懒加载策略，即在加载对象的同时，发出查询语句，加载其关联对象

proxy:这是hibernate对单端关联的默认懒加载策略，即只有在调用到其关联对象的方法的时候才真正发出查询语句查询其对象数据，其关联对象是代理类

no-proxy:这种懒加载特性需要对类进行增强，使用no-proxy，其关联对象不是代理类

注意：在class标签上配置的lazy属性不会影响到关联对象!!!