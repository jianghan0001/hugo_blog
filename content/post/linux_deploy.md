
+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "linux部署服务器"
tags = [
  "linux"
]
+++


### jdk 安装

wget 官网链接，需要审查真正链接地址，响应为200的，为真实响应地址

如果网速慢的话，其他服务器或电脑上有的话建议用scp，比wget快很多。    

tar -zxvf jdk-8u101-linux-x64.tar.gz jdk1.8.0

### 配置环境变量

sudo vi /etc/profile
最下方添加如下

export JAVA_HOME=/env/jdk1.8.0
export MAVEN_HOME=/env/apache-maven-3.3.9
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH      //此处JAVA和 MAVEN 配置放在PATH前面，提升优先级，以免被替代
source /etc/profile

### maven 安装

wget 官网链接，需要审查真正链接地址，响应为200的，为真实响应地址

如果网速慢的话，其他服务器或电脑上有的话建议用scp，比wget快很多。

tar -zxvf maven.tar.gz


配置环境变量如上
export MAVEN_HOME=/env/apache-maven-3.3.9
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

source /etc/profile
### mysql 安装

centos6:    

rpm -qa | grep mysql　　// 这个命令就会查看该操作系统上是否已经安装了mysql数据库

rpm -e mysql　　// 普通删除模式
rpm -e --nodeps mysql　　// 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除

查看yum上提供的mysql数据库可下载的版本：
yum list | grep mysql

yum install -y mysql-server mysql mysql-deve   //安装

service mysqld start     //启动

通过  chkconfig --list | grep mysqld 命令来查看mysql服务是不是开机自动启动

通过 chkconfig mysqld on 命令来将其设置成开机启动

mysqladmin -u root password 'root'　　// 通过该命令给root账号设置密码为 root


centos7:

yum install mariadb-server mariadb-libs mariadb

systemctl start mariadb.service     //启动mysql

mysqladmin -u root password 'root'
### mysql远程连接

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
Mysql命令行导出导入数据库：

### 导出数据库：mysqldump -u 用户名 -p 数据库名 > 导出的文件名 
如我输入的命令行:
    mysqldump -u root -p atm > atm.sql   (输入后会让你输入进入MySQL的密码)
（如果导出单张表的话在数据库名后面输入表名即可）


### Mysql命令行导入数据库：


2.接着我们进入到MySQL Command Line     Client，输入密码，进入到“mysql>”，创建一个新的数据库(mysql>create database test;)

3.使用新创建的数据库 mysql>use test;

4.导入文件： mysql>source 导入的文件名;  比如我要导入我刚导出的atm.sql数据文件：     mysql>source atm.sql;

5.如果没有提示错误信息提示，我们可以通过show tables;指令可以看到新创建的test数据库里面已经导入了刚atm数据库里的内容。
yum安装git

yum install git
### 生成密钥

ssh-keygen 
### tomcat 安装

wget 官网链接，需要审查真正链接地址，响应为200的，为真实响应地址

如果网速慢的话，其他服务器或电脑上有的话建议用scp，比wget快很多。

tar -zxvf tomcat8.tar.gz


检测是否安装成功，./tomcat/bin/startup.sh

外网访问  ip:8080 

如果成功，显示tomcat主页

不成功，可能是云服务器后台没有开端口.
### redis 安装

  yum install gcc-c++
  yum install -y tcl
  yum install wget

 cd到要安装的目录

 sudo wget http://download.redis.io/releases/redis-3.2.4.tar.gz


 tar xzf redis-3.2.4.tar.gz   

cd 到redis目录

make
make install   

无权限则sudo make install 

显示如下则正确

Hint: It's a good idea to run 'make test' ;)

INSTALL install
INSTALL install
INSTALL install
INSTALL install
INSTALL install

make[1]: Leaving directory `/usr/local/redis/redis-3.2.4/src'
成功后 /usr/local/bin 下应该会有 redis-server 等redis的二进制文件

后台启动

redis-server &
### 可能出现的错误:

下载解压redis-2.0.4后，执行make进行编译，结果出现下面的错误：

make: cc: Command not found make: *** [adlist.o] Error 127

由于新安装的Linux系统没有安装gcc环境，需要安装gcc，为了方便，这里我选择用yum进行安装。

yum  install  gcc
### 搭建nginx (简单安装)**

rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

* 链接需要根据服务器系统查找匹配的rpm文件，http://nginx.org/packages/centos 中查找。

yum install nginx

service nginx start

然后进入浏览器，输入http://192.168.0.161/测试，如果看到 nginx主页，说明成功