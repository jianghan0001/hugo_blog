+++
tags = ["java"]
title = "hashmap原理"
draft = false
date = "2017-02-15T10:54:24+02:00"

+++

hashMap 本质就是数组，只不过数组的每个元素是一个链表， 链表的节点就是 k-v 对。

每次put(k, v) 时，按 hash(k) ,计算数组下表，然后在该处增加一个节点而已。

