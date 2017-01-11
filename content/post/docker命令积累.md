+++
tags = ["docker"]
title = "docker命令积累"
draft = false
date = "2017-01-10T10:54:24+02:00"

+++


docker ps   #查看正在运行中的容器

docker ps -a  #查看所有容器


docker rm 容器id   #删除容器，id可以是前几位
  
删除所有容器      
    
    docker rm `sudo docker ps -a -q`   

  

docker rmi 镜像id  #删除镜像  


 

docker inspect 容器id   #查看container的实例属性，比如ip等  



 

-t 表示在新容器内指定一个伪终端或终端，

-i表示允许我们对容器内的 (STDIN) 进行交互。

-d 标识是让 docker 容器在后台运行

-P 标识通知 Docker 将容器内部使用的网络端口映射到我们使用的主机上  
-P 标识(flags)是 -p 5000 的缩写，它将会把容器内部的 5000 端口映射到本地 Docker 主机的高位端口上(这个端口的通常范围是 32768 至 61000)。我们也可以指定 -p 标识来绑定指定端口。





使用 exit 命令或者使用 CTRL-D 来退出容器。

docker ps 列出容器

docker logs 显示容器的标准输出

docker stop 停止正在运行的容器



docker logs 容器id  #查看docker实例运行日志，确保正常运行 


sudo docker logs -f nostalgic_morse
  
这次我们添加了一个 -f 标识。 docker log 命令就像使用 tail -f 一样来输出容器内部的标准输出。这里我们从显示屏上可以看到应用程序使用的是 5000 端口并且能够查看到应用程序的访问日志。

 docker commit 命令。这里我们指定了两个标识(flags) -m 和 -a 。-m 标识我们指定提交的信息，就像你提交一个版本控制。-a 标识允许对我们的更新来指定一个作者




Dockerfile 中的每一条命令都一步一步的被执行。我们会看到每一步都会创建一个新的容器，在容器内部运行指令并且提交更改 - 就像我们之前使用的 docker commit 一样。当所有的指令执行完成之后，我们会得到97feabe5d2ed 镜像（也帮助标记为 ouruser/sinatra:v2）, 然后所有中间容器会被清除


可以在提交更改和构建之后为镜像来添加标签(tag)。我们可以使用 docker tag 命令。为我们的 ouruser/sinatra 镜像添加一个新的标签。

$ docker tag 5db5f8471261 ouruser/sinatra:devel