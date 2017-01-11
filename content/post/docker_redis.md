+++
tags = ["docker"]
title = "docker_多服务快速搭建"
draft = false
date = "2017-01-11T10:54:24+02:00"

+++

参考：http://wiki.jikexueyuan.com/project/docker-technology-and-combat/appendix_storage.html


MySQL

基本信息

MySQL 是开源的关系数据库实现。

该仓库提供了 MySQL 各个版本的镜像，包括 5.6 系列、5.7 系列等。

使用方法

默认会在 3306 端口启动数据库。

    $ sudo docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql

之后就可以使用其它应用来连接到该容器。

    $ sudo docker run --name some-app --link some-mysql:mysql -d application-that-uses-mysql

或者通过 mysql。

    $ sudo docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'



Nginx

基本信息

Nginx 是开源的高效的 Web 服务器实现，支持 HTTP、HTTPS、SMTP、POP3、IMAP 等协议。 该仓库提供了 Nginx 1.0 ~ 1.7 各个版本的镜像。

使用方法

下面的命令将作为一个静态页面服务器启动。

    $ sudo docker run --name some-nginx -v /some/content:/usr/share/nginx/html:ro -d nginx

用户也可以不使用这种映射方式，通过利用 Dockerfile 来直接将静态页面内容放到镜像中，内容为

FROM nginx
COPY static-html-directory /usr/share/nginx/html
之后生成新的镜像，并启动一个容器。

    $ sudo docker build -t some-content-nginx .
    $ sudo docker run --name some-nginx -d some-content-nginx
开放端口，并映射到本地的 8080 端口。

    sudo docker run --name some-nginx -d -p 8080:80 some-content-nginx

Nginx的默认配置文件路径为 /etc/nginx/nginx.conf，可以通过映射它来使用本地的配置文件，例如

    docker run --name some-nginx -v /some/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx

使用配置文件时，为了在容器中正常运行，需要保持 daemon off;。



Redis

基本信息

Redis 是开源的内存 Key-Value 数据库实现。

该仓库提供了 Redis 2.6 ~ 2.8.9 各个版本的镜像。

使用方法

默认会在 6379 端口启动数据库。

    $ sudo docker run --name some-redis -d redis

另外还可以启用 持久存储。

    $ sudo docker run --name some-redis -d redis redis-server --appendonly yes
默认数据存储位置在 VOLUME/data。可以使用 --volumes-from some-volume-container 或 -v /docker/host/dir:/data 将数据存放到本地。

使用其他应用连接到容器，可以用

    $ sudo docker run --name some-app --link some-redis:redis -d application-that-uses-redis
或者通过 redis-cli

    $ sudo docker run -it --link some-redis:redis --rm redis sh -c 'exec redis-cli -h "$REDIS_PORT_6379_TCP_ADDR" -p "$REDIS_PORT_6379_TCP_PORT"'