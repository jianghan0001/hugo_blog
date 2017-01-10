+++
tags = ["docker"]
title = "docker安装"
draft = false
date = "2017-01-10T10:54:24+02:00"

+++



安装EPEL

EPEL 是yum的一个软件源，里面包含了许多基本源里没有的软件。（安装需要连接网络）
安装了这个源后，就可以使用yum来安装 docker了。  

    yum install epel-release-7   

安装过程需要交互，输入“y”按回车就可以了。

验证是否安装成功：
yum repolist



安装Docker-io

    yum -y install docker-io

配置开机自启动：


    systemctl enable docker.service

完成后，启动服务：  
    
    
    systemctl start docker.service  

应用Docker

通过下面命令来验证doecker是否安装成功: 
 
    docker info



使用下面命令网络仓库下载需要镜像：  

    docker pull centos:latest #下载centos  
    docker pull ubutun:latest #下载ubutun  

使用下面命令查看当前镜像：  

    docker images


在列出信息中，可以看到几个字段信息

来自于哪个仓库，比如 docker.io/ubuntu  
镜像的标记，比如latest  
它的 ID 号（唯一）07f8e8c5e660  
创建时间  
镜像大小  
使用docker完成“hello world":    
 
    docker run ubuntu:07f8e8c5e660 /bin/echo ‘hello world‘   
    docker run centos:fd44297e2ddb /bin/echo ‘hello docker‘  


上面的命令界面显示只会显示hello docker ，

docker 再 docker start 容器id 的时候还会执行一遍echo hello docker ，但界面只显示容器id ，并随之关闭该容器,  

使用docker logs 容器id可以看到执行的结果多了一条hello docker