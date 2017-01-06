+++
tags = ["docker"]
title = "docker学习笔记"
draft = false
date = "2017-01-06T10:54:24+02:00"

+++

### 安装下载镜像

https://docs.docker.com/engine/installation/linux/centos/

windows 安装虚拟机 centos7 

1.yum正常安装docker

$ sudo yum update

// Add the yum repo.



$ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository  
baseurl=https://yum.dockerproject.org/repo/main/centos/7/  
enabled=1  
gpgcheck=1  
gpgkey=https://yum.dockerproject.org/gpg  
EOF  



// Install the Docker package.  
$ sudo yum install docker-engine

// Enable the service.  
$ sudo systemctl enable docker.service

// Start the Docker daemon.  
$ sudo systemctl start docker



// Verify docker is installed correctly by running a test image in a container.  
$ sudo docker run --rm hello-world


2.脚本安装docker

// Make sure your existing packages are up-to-date.  
$ sudo yum update 

// Run the Docker installation script.  
$ curl -fsSL https://get.docker.com/ | sh

// This script adds the docker.repo repository and installs   Docker.  
// Enable the service.  
$ sudo systemctl enable docker.service  

// Start the Docker daemon.
$ sudo systemctl start docker  

// Verify docker is installed correctly by running a test image in a container.  
$ sudo docker run --rm hello-world



3 . 设置开机启动


//Configure the Docker daemon to start automatically when the host starts:

$ sudo systemctl enable docker  


4 . Uninstall  卸载  

You can uninstall the Docker software with yum.

List the installed Docker packages.  

$ yum list installed | grep docker

docker-engine.x86_64                   1.12.3-1.el7.centos             @dockerrepo
docker-engine-selinux.noarch           1.12.3-1.el7.centos             @dockerrepo
Remove the package.  

$ sudo yum -y remove docker-engine.x86_64  
$ sudo yum -y remove docker-engine-selinux.noarch    

This command does not remove images, containers, volumes, or user-created configuration files on your host.
To delete all images, containers, and volumes, run the following command:  

$ rm -rf /var/lib/docker  
Locate and delete any user-created configuration files.




### 下载镜像启动容器

sudo docker pull index.alauda.cn/alauda/ubuntu

//查看镜像  
docker images


//启动容器,将宿主机和容器目录共享,准备安装程序

docker run <相关参数> <镜像 ID> <初始命令>

-i：表示以“交互模式”运行容器
-t：表示容器启动后会进入其命令行
-v：表示需要将本地哪个目录挂载到容器中，
格式：-v <宿主机目录>:<容器目录>

我的相关程序都在当前机器的/data/software/目录下，并且想把它挂载到容器的相同目录下：

sudo docker run -i -t -v /data/software/:/data/software/ ae983d5e88ce /bin/bash

“镜像 ID”，也可以使用“仓库名:标签名”，例如：index.alauda.cn/alauda/ubuntu :latest。

上面的命令，可以使用指定的镜像运行一个shell，如果想退出该终端，可以使用exit命令，
或者依次按下CTRL -p+CTRL -q，即可切换到宿主机器。不过这种方式，容器依然在后天运行。



### 安装JDK和Tomcat等

安装相关的JDK等程序，这里全部安装到/data/目录：

tar -zxvf jdk-7u25-linux-x64.tar.gz -C /data/
mv jdk1.7.0_25 jdk

unzip apache-tomcat-7.0.54.zip -d /data/
mv apache-tomcat-7.0.54 tomcat

配置环境变量

vi /etc/profile

添加下面的配置：

  
export JAVA_HOME=/data/jdk   
export JRE_HOME=${JAVA_HOME}/jre   
export CLASSPATH=.:JAVAHOME/lib:{JRE_HOME}/lib   
export PATH=JAVAHOME/bin:PATH  

export CATALINA_HOME=/data/tomcat  
export CATALINA_BASE=/data/tomcat  

保存并退出，设置立即生效：

source /etc/profile


### 编写启动脚本

启动tomcat时必须通过TOMCATHOME/bin/catalina.sh实现，不能使用TOMCAT_HOME/bin/startup.sh启动，否则脚本执行后容器会马上退出。

vi /data/start.sh

添加以下内容：

    #!/bin/bash
    # Export environment variable
    source /etc/profile
    # Start tomcat
    bash /data/tomcat/bin/catalina.sh run

添加可执行权限：

chmod u+x /data/start.sh

## 构建镜像

使用Docker构建镜像的两种方法：

使用docker commit 命令，更直观一些；

使用docker build命令和Dockerfile文件，可以模板化镜像构建过程；

这里使用docker commit的方式创建镜像。

提交一个新的镜像：

sudo docker commit 39b2cf60a4c1 bingyue/docdemo

如果有Docker账号，可以将镜像推送到Docker Hub或资金的私有Registry中。

现在查看本地的docker镜像，  
可以看到本地仓库已经有刚刚创建的docker镜像。

## docker inspect可以查看新创建的镜像的详细信息：

sudo docker inspect bingyue/docdemo  

## 运行新创建的镜像

docker run -d -p 18080:8080 --name docdemo bingyue/docdemo /data/start.sh

-p：表示宿主机与容器的端口映射，此时将容器内部的 8080 端口映射为宿主机的 18080 端口，

这样就向外界暴露了 18080 端口，可通过 Docker 网桥来访问容器内部的 8080 端口了。

查看后台是否启动成功：

docker ps   

成功启动，访问宿主机的18080端口是否可以访问到tomcat服务器，成功则表示端口映射成功.


## 添加Docker用户组，避免sudo输入

默认安装完 docker 后，每次执行 docker 都需要运行 sudo 命令，影响效率。如果不跟 sudo，直接执行 docker images 命令会有如下问题：
Get http:///var/run/docker.sock/v1.18/images/json: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS?
把当前用户执行权限添加到相应的docker用户组里面就可以解决这个问题。

添加一个新的docker用户组
sudo groupadd docker

#### 添加当前用户到docker用户组里
sudo gpasswd -a bingyue docker
#### 重启Docker后台监护进程
sudo service docker restart
#### 重启之后，尝试一下，是否生效
docker version
#### 若还未生效，则系统重启，则生效
sudo reboot

## Docker常用命令

#### 下载一个ubuntu镜像 
sudo docker pull ubuntu
#### 使用ubuntu运行一个交互性的shell
sudo docker run -i -t ubuntu /bin/bash
#### docker ps命令
sudo docker ps #列出当前所有正在运行的container
sudo docker ps -l #列出最近一次启动的，且正在运行的container
sudo docker ps -a #列出所有的container
#### port命令
docker run -p 80:8080 <image> <cmd> #映射容器的8080端口到宿主机的80端口
#### 删除容器命令
sudo docker rm `sudo docker ps -a -q`#删除所有容器
sudo docker rm $CONTAINER_ID#删除容器id为CONTAINER_ID的容器
#### 其他命令快速参考：
sudo docker images #查看本地镜像
sudo docker attach $CONTAINER_ID #启动一个已存在的docker实例
sudo docker stop $CONTAINER_ID #停止docker实例
sudo docker logs $CONTAINER_ID #查看docker实例运行日志，确保正常运行
sudo docker inspect $CONTAINER_ID #查看container的实例属性，比如ip等等

