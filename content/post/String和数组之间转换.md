+++
tags = ["java"]
title = "String和数组之间转换"
draft = false
date = "2017-02-09T22:54:24+02:00"

+++

	String strStringType="my string"; 
	//创建一个字符串变量strStringType
	char[] chrCharArray; //创建一个字符数组chrCharArray
	chrCharArray = strStringType.toCharArray(); //将字符串变量转换为字符数组
	strStringType= String.valueOf(chrCharArray ); //将字符数组转换为字符串