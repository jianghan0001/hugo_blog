+++
title = "list去重"
draft = false
date = "2016-12-26T10:54:24+02:00"
tags = ["java"]

+++


## 一行代码去重

1.不带类型写法：

List listWithoutDup = new ArrayList(new HashSet(listWithDup));

2.带类型写法（以String类型为例）： 
1)Java 7以下写法：

List listWithoutDup = new ArrayList(new HashSet(listWithDup));


2)Java 7及以上写法：

List listWithoutDup = new ArrayList<>(new HashSet<>(listWithDup));


## 更高效的去重，并根据属性去重:



    private ArrayList<Model> distinctList(ArrayList<Model> list){
        ArrayList<Model> newList = new ArrayList<Model>();
        Set<String> set = new HashSet<String>();
        for (Model item:list){
           if (set.add(item.str)){
                newList.add(item);
            }
        }
        return newList;
    }



    class Model {
        public int id;
        public String str;
    }


