+++
date = "2016-12-20T10:10:20+08:00"
draft = false
tags = [
  "linux"
]
title="deepin安装常用软件"
+++




### 安装maven git

* sudo apt-get install maven
* sudo apt-get install git

### 安装redis：

sudo apt-get update  
sudo apt-get install redis-server


### 安装shadowsocks：

1.建议选择商店里的shadowsocks客户端

2.使用命令行下载
http://www.cnblogs.com/shijingjing07/p/5479558.html


apt-get install python-pip  
pip install shadowsocks  

shadowsocks已经安装好在 ～/.local/下  有sslocal命令文件  
主目录下创建shadowsocks.json 文件  
{  
"server":"vpn.suconghou.cn",   
"server_port":443,  
"local_port":1080,  
"password":"****",  
"timeout":600,  
"method":"aes-256-cfb"  
}  





### 配置浏览器:

需要给chrome安装SwitchyOmega插件，但是没有代理之前是不能从谷歌商店安装这个插件的，  
但是我们可以从Github上直接下载最新版 https://github.com/FelisCatus/SwitchyOmega/releases/ （这个是chrome的）   
然后浏览器地址打开chrome://extensions/，将下载的插件托进去安装。

新建情景模式 ss ，代理服务器 , socks5协议.  

auto-switch 模式

原始的两个规则删除

添加规则列表:

AutoProxy

规则网址：
https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

点 立即更新情景模式

上面规则先是ss，下面默认是直接连接.

点 应用选项


