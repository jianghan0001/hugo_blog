+++
tags = ["docker"]
title = "docker hub的使用"
draft = false
date = "2017-01-10T22:54:24+02:00"

+++

Docker通过docer search、pull、login和push等命令提供了连接Docker Hub服务的功能



在Docker Hub创建你的账户，或通过运行：

$ sudo docker login  

这将提示您输入用户名，这个用户名将成为你的公共存储库的命名空间名称。如果你的名字可用，docker会提示您输入一个密码和你的邮箱，然后会自动登录到Docker Hub，你现在可以提交和推送镜像到Docker Hub的你的存储库。




推送镜像到 Docker Hub

一旦你构建或创建了一个新的镜像，你可以使用 docker push 命令将镜像推送到 Docker Hub 。这样你就可以分享你的镜像了，镜像可以是公开的，或者你可以把镜像添加到你的私有仓库中。
    
    $ docker push ouruser/sinatra
    The push refers to a repository [ouruser/sinatra] (len: 1)
    Sending image list
    Pushing repository ouruser/sinatra (3 tags)
    . . . 

镜像上传之后你的团队或者社区的人都可以使用它。

