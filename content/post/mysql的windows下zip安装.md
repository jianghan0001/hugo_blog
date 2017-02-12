+++
tags = ["数据库"]
title = "mysql的windows下zip安装"
draft = false
date = "2017-02-12T22:54:24+02:00"

+++

1 . 先解压，修改my_default.ini 文件里 basedir 和 datadir 的路径

2 . 修改环境变量，将mysql的bin添加到path，

3 . 以管理员身份打开cmd 窗口

   执行mysqld -install

4 . 将my_default.ini 复制一份到 bin ，改为my.ini ，执行

mysqld --initialize --user=mysql --console   
则生成data文件夹，并生成root 账号的密码！！


![](http://i.imgur.com/cMFYXzD.png)


5 . 命令行下执行 net start mysql 开启mysql服务

6 . mysql -u root -p 登录

输入上图中的密码，即可登陆
7 . 修改root密码

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');