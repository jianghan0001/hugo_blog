+++
tags = ["docker"]
title = "docker搭建web开发环境"
draft = false
date = "2017-01-07T10:54:24+02:00"

+++



前提：假设你已安装docker 并已经启动了docker

docker pull centos



#### 启动容器：

只需使用以下命令即可启动容器：

docker run -i -t -v /root/software/:/mnt/software/ 25c5298b1a36 /bin/bash  

这条命令比较长，我们稍微分解一下，其实包含以下三个部分：

docker run <相关参数> <镜像 ID> <初始命令>
其中，相关参数包括：

-i：表示以“交互模式”运行容器  
-t：表示容器启动后会进入其命令行   
-v：表示需要将本地哪个目录挂载到容器中，格式：-v <宿主机目录>:<容器目录>    

假设我们的所有安装程序都放在了宿主机的/root/software/目录下，现在需要将其挂载到容器的/mnt/software/目录下。  


需要说明的是，不一定要使用“镜像 ID”，也可以使用“仓库名:标签名”，例如：docker.cn/docker/centos:centos6。

初始命令表示一旦容器启动，需要运行的命令，此时使用“/bin/bash”，表示什么也不做，只需进入命令行即可。  



#### 安装jdk

我是进入容器 yum 安装的jdk， 相必也可以用-v 挂在目录，解压现有tar包安装

看你的网速了吧，网速很差的话建议用scp传文件到服务器，再挂载解压.

查看当前的jdk版本，并卸载

    [root@localhost opt]#  rpm -qa|grep java 
    java-1.6.0-openjdk-1.6.0.37-1.13.9.4.el5_11
    tzdata-java-2015g-1.el5
    //卸载
    [root@localhost opt]# rpm -e --allmatches --nodeps java-1.6.0-openjdk-1.6.0.37-1.13.9.4.el5_11
    [root@localhost opt]# rpm -e --allmatches --nodeps tzdata-java-2015g-1.el5



yum search jdk

yum install java-1.8.0-openjdk.x86_64

java -version

通过yum默认安装的路径为

  /usr/lib/jvm





####安装tomcat


yum install tomcat



yum -y install wget

wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz



tar -zxvf apache-tomcat-8.5.9.tar.gz

mv apache-tomcat-8.5.9.tar.gz tomcat8




#### docker进入容器

有四种方法，这里用

docker attach 容器id


还有ssh nsenter exec方法，待研究.





#### 端口映射


将容器端口和主机端口进行映射

再run 这个镜像时可以 -p 参数设置主机容器的端口映射

或者将容器提交为镜像，再run的时候添加端口映射





#### 用 commit 命令创建镜像


可以想象是往版本控制系统里提交变更：首先创建一个容器，并在容器里做修改，就行修改代码一样，最后在讲修改提交为一个新镜像。


共享和发布镜像时构建镜像中重要的环节，可以将镜像推送到Docker Hub或资金的私有Registry中。首先需要创建一个账号，远程仓库，存取你的镜像。（类似git）

然后在docker中登录账号，认证

$ sudo docker login

输入账号密码

这条命令会完成登录，并将认证信息报错起来供后面使用。个人认证信息将报错到$HOME/ .dockercfg文件中.


所以先用exit命令退出容器，再运行docker commit命令：

$ sudo docker commit 614122c0aabb aoct/apache2



#### 使用docker inspect命令查看新创建的镜像的详细信息：

$ sudo docker inspect aoct/apache2  



