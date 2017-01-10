+++
tags = ["docker"]
title = "docker搭建jdk+tomcat"
draft = false
date = "2017-01-10T10:54:26+02:00"

+++


首先，需要映射端口，docker run的时候需要将本机80端口和容器8080端口映射


这样访问本机80即访问容器8080

如果添加redis支持的话，应该还要映射一个redis端口，将本机redis端口和容器redis端口，映射，这样容器中tomcat需要redis支持时便可获得本机redis支持


使用下面命令网络仓库下载需要镜像：  

    docker pull centos:latest #下载centos    


镜像下载到本地以后，就可以使用Docker运行，  
通过下面的命令参数启动容器，  

docker run <相关参数> <镜像 ID> <初始命令>  

-i：表示以“交互模式”运行容器  
-t：表示容器启动后会进入其命令行  
-v：表示需要将本地哪个目录挂载到容器中，  
格式：-v <宿主机目录>:<容器目录>  

我的相关程序都在当前机器的/data/software/目录下，并且想把它挂载到容器的相同目录下：  
 

    sudo docker run -i -t --privileged=true -v /data/software/:/data/software/ ae983d5e88ce /bin/bash

“镜像 ID”，也可以使用“仓库名:标签名”，例如：index.alauda.cn/alauda/ubuntu :latest。  

上面的命令，可以使用指定的镜像运行一个shell，如果想退出该终端，可以使用exit命令，  
或者依次按下CTRL -p+CTRL -q，即可切换到宿主机器。不过这种方式，容器依然在后天运行。  


1. 这里不用先暴露端口，之后安装成功后会生成镜像，再通过镜像生成新的容器时暴露端口即可.  

2. 先在本机下载tomcat和jdk的tar包，通过数据卷挂载，挂载到容器中

最好还是scp到主机，wget下载太慢，





##### 挂载之后挂载目录没有权限

    sudo docker run -i -t --privileged=true -v /data/software/:/data/software/ ae983d5e88ce /bin/bash




##### 解压配置环境变量

然后将jdk 和 tomcat解压到 /env/ 下 , tar xzvf abc.tar.gz -C /env/

vi /etc/profile


    #set java environment   
    export JAVA_HOME=/env/jdk7   
    export JRE_HOME=$JAVA_HOME/jre   
    export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    export PATH=$JAVA_HOME/bin:$PATH    



source /etc/profile    //即时生效

##### 编写tomcat启动脚本

    #!/bin/bash
	# Export environment variable
	source /etc/profile
    # Start tomcat
    bash /env/tomcat8/bin/catalina.sh run 


为start.sh添加执行权限


##### 构建镜像

使用Docker构建镜像的两种方法：

使用docker commit 命令，更直观一些；

使用docker build命令和Dockerfile文件，可以模板化镜像构建过程；


此时exit出来 

此处用commit，关于dockerfile会另写一篇笔记。

执行


    sudo docker commit 39b2cf60a4c1 ruushwei/jdk_tomcat



关于提交到公共仓库 docker Hub ，会专门写一篇相关笔记


此时 docker images 就可以看到刚才提交的镜像已经生成了

查看镜像详细信息
    
    docker inspect ruushwei/jdk_tomcat 




##### 根据镜像创建后台tomcat进程

    docker run -d -p 18080:8080 --name demo ruushwei/jdk_tomcat2 /env/start.sh



docker ps 查看正在运行的容器


如果正在运行，应该就可以了，查看本机18080端口，看是否出现如下可爱的tom猫


![](http://i.imgur.com/q4FCv2B.png)


