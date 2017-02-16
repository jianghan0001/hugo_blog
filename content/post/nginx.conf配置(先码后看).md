	
+++
tags = ["nginx"]
title = "nginx.conf配置(先码后看)"
draft = false
date = "2017-02-16T10:54:24+02:00"

+++




	1. Apache服务器和nginx的优缺点：
	我们之前大量使用Apache来作为HTTPServer。
	Apache具有很优秀的性能，而且通过模块可以提供各种丰富的功能。
	1)首先Apache对客户端的响应是支持并发的 ，运行httpd这个daemon进程之后，它会同时产生多个孩子进程/线程，每个孩子进程/线程分别对客户端的请求进行响应；
	2)另外，Apache可以提供静态和动态的服务 ，例如对于PHP的解析不是通过性能较差的CGI实现的而是通过支持PHP的模块来实现的(通常为mod_php5，或者叫做apxs2)。
	3)缺点:
	因此通常称为Apache的这种Server为process-based server ，也就是基于多进程的HTTPServer，因为它需要对每个用户请求创建一个孩子进程/线程进行响应；
	这样的缺点是，如果并发的请求非常多(这在大型门户网站是很常见的)就会需要非常多的线程，从而占用极多的系统资源CPU和内存。因此对于并发处理不是Apache的强项。
	4)解决方法：
	目前来说出现了另一种WebServer，在并发方面表现更加优越，叫做asynchronous servers异步服务器。最有名的为Nginx和Lighttpd。所谓的异步服务器是事件驱动程序模式的event-driven，除了用户的并发请求通常只需要一个单一的或者几个线程。因此占用系统资源就非常少。这几种又被称为lightweight web server。
	举例，对于10,000的并发连接请求，nginx可能仅仅使用几M的内存；而Apache可能需要使用几百M的内存资源。
	2. 实际中单一的使用：
	1)关于单一使用Apache来作为HTTPServer的情况我们不用再多做介绍，非常常见的应用；
	上面我们介绍到Apache对于PHP等服务器端脚本的支持是通过自己的模块来实现的，而且性能优越。
	2)我们同样可以单单使用nginx或者lighttpd来作为HTTPServer来使用。
	nginx和lighttpd和Apache类似都通过各种模块可以对服务器的功能进行丰富的扩展，同样都是通过conf配置文件对各种选项进行配置。
	对于PHP等，nginx和lighttpd都没有内置的模块来对PHP进行支持，而是通过FastCGI来支持的。
	Lighttpd通过模块可以提供CGI, FastCGI和SCGI等服务，Lighttpd is capable of automatically spawning FastCGI backends as well as using externally spawned processes.
	nginx则没有自己提供处理PHP的功能，需要通过第三方的模块来提供对PHP进行FastCGI方式的集成。
	 
	 
	 
	 
	===============Nginx配置文件nginx.conf中文详解
	 
	 
	#定义Nginx运行的用户和用户组
	
	
	user www www;   
	 #nginx进程数，建议设置为等于CPU总核心数。
	worker_processes
	
	 8;
	
	 #全局错误日志定义类型，[ debug | info | notice | warn | error | crit ]
	
	
	error_log /var/log/nginx/error.log info;
	
	 #进程文件
	
	
	pid /var/run/nginx.pid;
	
	#一个nginx进程打开的最多文件描述符数目，理论值应该是最多打开文件数（系统的值ulimit -n）与nginx进程数相除，但是nginx分配请求并不均匀，所以建议与ulimit -n的值保持一致。
	
	
	worker_rlimit_nofile 65535;
	
	#工作模式与连接数上限
	
	
	events
	
	
	{
	
	
	#参考事件模型，use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll模型是Linux
	
	 2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型。
	
	
	use epoll;
	
	
	#单个进程最大连接数（最大连接数=连接数*进程数）
	
	
	worker_connections 65535;
	
	
	}
	
	
	
	#设定http服务器
	
	
	http
	
	
	{
	
	
	include mime.types; #文件扩展名与文件类型映射表
	
	
	default_type application/octet-stream; #默认文件类型
	
	
	#charset utf-8; #默认编码
	
	
	server_names_hash_bucket_size 128; #服务器名字的hash表大小
	
	
	client_header_buffer_size 32k; #上传文件大小限制
	
	
	large_client_header_buffers 4 64k; #设定请求缓
	
	
	client_max_body_size 8m; #设定请求缓
	
	
	sendfile on; #开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为 
	on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改
	成off。
	
	
	autoindex on; #开启目录列表访问，合适下载服务器，默认关闭。
	
	
	tcp_nopush on; #防止网络阻塞
	
	
	tcp_nodelay on; #防止网络阻塞
	
	
	keepalive_timeout 120; #长连接超时时间，单位是秒
	
	#FastCGI
	
	相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
	
	
	fastcgi_connect_timeout 300;
	
	
	fastcgi_send_timeout 300;
	
	
	fastcgi_read_timeout 300;
	
	
	fastcgi_buffer_size 64k;
	
	
	fastcgi_buffers 4 64k;
	
	
	fastcgi_busy_buffers_size 128k;
	
	
	fastcgi_temp_file_write_size 128k;
	
	#gzip模块设置
	
	
	gzip on; #开启gzip压缩输出
	
	
	gzip_min_length 1k; #最小压缩文件大小
	
	
	gzip_buffers 4 16k; #压缩缓冲区
	
	
	gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
	
	
	gzip_comp_level 2; #压缩等级
	
	
	gzip_types text/plain application/x-javascript
	
	 text/css application/xml;
	
	
	#压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
	
	
	gzip_vary on;
	
	
	#limit_zone crawler $binary_remote_addr 10m; #开启限制IP连接数的时候需要使用
	
	upstream blog.ha97.com {
	
	
	#upstream的负载均衡，weight是权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。
	
	
	server 192.168.80.121:80 weight=3;
	
	
	server 192.168.80.122:80 weight=2;
	
	
	server 192.168.80.123:80 weight=3;
	
	
	}
	
	#虚拟主机的配置
	
	
	server
	
	
	{
	
	
	#监听端口
	
	
	listen 80;
	
	
	#域名可以有多个，用空格隔开
	
	
	server_name www.ha97.com ha97.com;
	
	
	index index.html index.htm index.php;
	
	
	root /data/www/ha97;
	
	
	location ~ .*.(php|php5)?$
	
	
	{
	
	
	fastcgi_pass 127.0.0.1:9000;
	
	
	fastcgi_index index.php;
	
	
	include fastcgi.conf;
	
	
	}
	
	
	#图片缓存时间设置
	
	
	location ~ .*.(gif|jpg|jpeg|png|bmp|swf)$
	
	
	{
	
	
	expires 10d;
	
	
	}
	
	
	#JS和CSS缓存时间设置
	
	
	location ~ .*.(js|css)?$
	
	
	{
	
	
	expires 1h;
	
	
	}
	
	
	#日志格式设定
	log_format
	
	 access '$remote_addr - $remote_user [$time_local] "$request" '
	
	
	'$status $body_bytes_sent "$http_referer" '
	
	
	'"$http_user_agent" $http_x_forwarded_for';
	
	
	#定义本虚拟主机的访问日志
	
	
	access_log /var/log/nginx/ha97access.log access;
	
	#对 "/" 启用反向代理
	
	
	location / {
	
	
	proxy_pass http://127.0.0.1:88;
	
	
	proxy_redirect off;
	
	
	proxy_set_header X-Real-IP $remote_addr;
	
	
	#后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
	
	
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	
	
	#以下是一些反向代理的配置，可选。
	
	
	proxy_set_header Host $host;
	
	
	client_max_body_size 10m; #允许客户端请求的最大单文件字节数
	
	
	client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
	
	
	proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
	
	
	proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
	
	
	proxy_read_timeout 90; #连接成功后，后端服务器响应时间(代理接收超时)
	
	
	proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
	
	
	proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
	
	
	proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
	
	
	proxy_temp_file_write_size 64k;
	
	
	#设定缓存文件夹大小，大于这个值，将从upstream服务器传
	
	
	}
	
	#设定查看Nginx状态的地址
	
	
	location /NginxStatus {
	
	
	stub_status on;
	
	
	access_log on;
	
	
	auth_basic "NginxStatus";
	
	
	auth_basic_user_file conf/htpasswd;
	
	
	#htpasswd文件的内容可以用apache
	
	提供的htpasswd工具来产生。
	
	
	}
	
	 
	 
	 
	#本地动静分离反向代理配置
	
	
	#所有jsp的页面均交由tomcat
	
	或resin
	
	处理
	
	
	location ~ .(jsp|jspx|do)?$ {
	
	
	proxy_set_header Host $host;
	
	
	proxy_set_header X-Real-IP $remote_addr;
	
	
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	
	
	proxy_pass http://127.0.0.1:8080;
	
	
	}
	
	
	#所有静态文件由nginx直接读取不经过tomcat或resin
	
	
	location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
	
	
	{ expires 15d; }
	
	
	location ~ .*.(js|css)?$
	
	
	{ expires 1h; }
	
	
	}
	
	
	}
	 
	=================
	 
	 
	每个nginx进程消耗的内存10兆的模样
	
	查看当前的PHP FastCGI进程数是否够用：
	netstat -anpo | grep "php-cgi" | wc -l
	　　如果实际使用的“FastCGI进程数”接近预设的“FastCGI进程数”，那么，说明“FastCGI进程数”不够用，需要增大。
	 
	 
	 
	------------------------------ error_log 日志分为 
	
	nginx的log有以下几种类型： [ debug | info | notice | warn | error | crit ] 
	在nginx.conf的设置：error_log logs/error.log  debug;
	debug 为最详细 crit最少
	 
	 
	 
	------------------------------- rewrites 所有非www.***.com的访问 => http://www.***.com/
	 server_name   web90.***.com;
	 
	 if ($host = "web90.***.com") {
	                rewrite ^(.*)$ http://www.test.com$1 permanent;
	        }
	 
	---------------------------------nginx 停止/平滑重启
	nginx的信号控制
	TERM,INT 快速关闭 
	QUIT  从容关闭
	HUP   平滑重启，重新加载配置文件
	USR1  重新打开日志文件，在切割日志时用途比较大
	USR2  平滑升级可执行程序
	WINCH 从容关闭工作进程
	 
	 
	1） 从容停止：
	kill -QUIT Nginx主进程号
	kill -QUIT '/usr/local/webserver/nginx/logs/nginx.pid'
	 
	2）快速停止：
	kill -TERM Nginx主进程号
	kill -TERM '/usr/local/webserver/nginx/logs/nginx.pid'
	kill -INTN ginx主进程号
	kill -INT  '/usr/local/webserver/nginx/logs/nginx.pid'
	 
	3）强制停止所有nginx进程
	pkill -9 nginx
	 
	 
	 
	1）平滑重启
	kill -HUP nginx主进程号
	kill -HUP '/usr/local/webserver/nginx/logs/nginx.pid'
	 
	 
	 
	 
	
	---------------------------- Location语法
	 
	location [=|~|~*|^~] /uri/ { … }
	
	= 开头表示精确匹配
	^~ 开头表示uri以某个常规字符串开头，理解为匹配 url路径即可
	~ 为区分大小写匹配
	~* 为不区分大小写匹配
	!~和!~*分别为区分大小写不匹配及不区分大小写不匹配
	/ 通用匹配，任何请求都会匹配到。
	多个location配置的情况下匹配顺序为
	首先匹配 =，其次匹配^~, 其次是按文件中顺序的正则匹配，最后是交给 / 通用匹配。当有匹配成功时候，停止匹配，按当前匹配规则处理请求。
	处理静态文件请求，这是nginx作为http服务器的强项
	# 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用
	location ^~ /static/ {
	root /webroot/static/;
	}
	location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
	root /webroot/res/;
	}
	 
	---------------------------- ReWrite语法 
	last – 基本上都用这个Flag。
	break – 中止Rewirte，不在继续匹配
	redirect – 返回临时重定向的HTTP状态302
	permanent – 返回永久重定向的HTTP状态301
	 
	----------------------------开启记录nginx access log中post请求
	 
	vim /usr/local/nginx/conf/vhost/ssc.conf
	
	log_format access '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent $request_body "$http_referer" "$
	http_user_agent" $http_x_forwarded_for';
	access_log logs/ssc.log access ;
	 
	------------------------------ 关闭 access log
	 
	server
	  {
	   access_log /dev/null;
	 
	}
	
	　　这样全部把他们丢到系统的黑洞里了。不用每时每刻都往系统磁盘疯狂的读写日志了 还延长硬盘的寿命。
	　　完全重启Nginx
	-----------------------------php-fpm
	php.ini中memory_limit设低了会出错，修改了php.ini的memory_limit为128M，重启nginx，发现好了，原来是PHP的内存不足了。
	 
	 
	 
	php-fpm 来管理FastCGI，可以修改配置文件中的以下值：
	 
	在PHP5.3.X中的php-fpm，配置文件 php-fpm.conf 对于进程管理有两种方法，一种是静态(static)，一种是动态(dynamic)。
	如果设置成 static，进程数始终都是 pm.max_children 指定的数量。 
	如果设置成 dynamic，则进程数是动态的，最开始是 pm.start_servers 指定的数量，如果请求较多，则会自动增加，保证空闲的进程数不小于pm.min_spare_servers，如果进程数较多，也会进行相应清理，保证进 程数不多于 pm.max_spare_servers。
	当php-fpm启动后，一个php-fpm进程处理过一些请求后，有些内存是释放不掉的，占用的内存将达到20M-30M不等。
	对于内存大的服务器（比如说4G）来说，指定静态的 max_children 后就不需要再进行额外的进程数目控制。比如我们指定为100个，那么php-fpm耗费的内存就能控制在大概2G，剩余的2G内存可以处理别的任务。
	如果内存小（比如1G），那么指定静态的进程数量，可以保证php-fpm只获取够用的内存，将不多的内存分配给其他应用去使用，有利于服务器的稳定,运行畅通。
	 
	
	
	    <value name="max_children">128</value>
	
	    同时处理的并发请求数，即它将开启最多128个子线程来处理并发连接。
	
	    <value name="rlimit_files">102400 </value>
	
	    最多打开文件数。
	
	    <value name="max_requests">204800 </value>
	
	    每个进程在重置之前能够执行的最多请求数。
	
	
	<value name="log_level">notice</value>
	<value name="process_control_timeout">5s</value> 
	<value name="display_errors">1</value>
	<value name="style">static</value> 
	<value name="StartServers">20</value>
	Sets the desired minimum number of idle server processes.
	Used only when 'apache-like' pm_style is selected
	<value name="MinSpareServers">5</value>
	Sets the desired maximum number of idle server processes.
	Used only when 'apache-like' pm_style is selected
	<value name="MaxSpareServers">35</value>
	<value name=”request_terminate_timeout”>30s</value>  fast-cgi的执行脚本时间 
	<value name="request_terminate_timeout">0s</value> 
	The timeout (in seconds) for serving of single request after which a php backtrace will be dumped to slow.log file'0s' means 'off'
	<value name="request_slowlog_timeout">2s</value> 
	The log file for slow requests
	<value name="slowlog">/data/logs/php/php-fpm-slow.log</value>
	 
	 
	-----------------------------fastcgi.conf
	 
	
	fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
	fastcgi_param  QUERY_STRING       $query_string;
	fastcgi_param  REQUEST_METHOD     $request_method;
	fastcgi_param  CONTENT_TYPE       $content_type;
	fastcgi_param  CONTENT_LENGTH     $content_length;
	
	fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
	fastcgi_param  REQUEST_URI        $request_uri;
	fastcgi_param  DOCUMENT_URI       $document_uri;
	fastcgi_param  DOCUMENT_ROOT      $document_root;
	fastcgi_param  SERVER_PROTOCOL    $server_protocol;
	
	fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
	fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
	
	fastcgi_param  REMOTE_ADDR        $remote_addr;
	fastcgi_param  REMOTE_PORT        $remote_port;
	fastcgi_param  SERVER_ADDR        $server_addr;
	fastcgi_param  SERVER_PORT        $server_port;
	fastcgi_param  SERVER_NAME        $server_name;
	
	# PHP only, required if PHP was built with --enable-force-cgi-redirect
	fastcgi_param  REDIRECT_STATUS    200;
	 
	 
	 
	=============================== nginx标识
	http://www.php100.com/html/webkaifa/apache/2011/0520/8098.html
	 
	以下为字符串匹配操作符
	~  为区分大小写匹配
	~* 为不区分大小写匹配
	!~和!~*分别为区分大小写不匹配及不区分大小写不匹配
	 
	
	
	文件和目录判断
	
	　　-f和!-f判断是否存在文件
	
	　　-d和!-d判断是否存在目录
	
	　　-e和!-e判断是否存在文件或目录
	
	　　-x和!-x判断文件是否可执行
	 
	 
	flag标记有：
	　　* last 相当于Apache里的[L]标记，表示完成rewrite
	　　* break 终止匹配, 不再匹配后面的规则
	　　* redirect 返回302临时重定向 地址栏会显示跳转后的地址
	　　* permanent 返回301永久重定向 地址栏会显示跳转后的地址
	　　一些可用的全局变量有，可以用做条件判断(待补全)
	　　$args
	　　$content_length
	　　$content_type
	　　$document_root
	　　$document_uri
	　　$host
	　　$http_user_agent
	　　$http_cookie
	　　$limit_rate
	　　$request_body_file
	　　$request_method
	　　$remote_addr
	　　$remote_port
	　　$remote_user
	　　$request_filename
	　　$request_uri
	　　$query_string
	　　$scheme
	　　$server_protocol
	　　$server_addr
	　　$server_name
	　　$server_port
	　　$uri
	      $http_referer
	 
	-----------------------------nginx.conf
	 
	查看物理cpu颗数
	 cat /proc/cpuinfo | grep physical | uniq -c
	      8 physical id     : 1
	(说明实际上是1颗8核的CPU)
	 
	在服务器上执行top，然后按1，就可以看到CPU内核的工作情况。如果多个CPU内核的利用率都相差不多，证明nginx己经成功的利用了多核CPU。
	 
	 
	 
	worker_processes 8;
	指定工作衍生进程数 ，一般等于cpu的总核数或总核数的两倍，例如两个四核的cpu，总核数为8
	
	events
	{
	  use epoll; //使用的网络i/o模型，linux系统推荐epoll,freebsd推荐kqueue
	  worker_connections 65535; //允许的链接数
	}
	 
	#max_clients = worker_processes * worker_connections
	 
	 
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
	{
	access_log off;关闭日志
	expires 30d;//通过expires指令输出Header头来实现本地缓存，30天
	}
	location ~ .*\.(js|css)$
	{
	access_log off;关闭日志
	expires 1h;
	}
	 
	 
	 
	====================== 重写
	 
	 
	 
	   if (!-e $request_filename ) {
	                                rewrite "/test/(.*[^js|css|jpg|gif|html])$" /index.php?r=test/$1 last;
	
	                                rewrite "(.*)([a|c|f])$" /static/login/$1$2/login.html last;
	                                rewrite "(.*)([a|c|f])/$" /static/login/$1$2/login.html last;
	                                rewrite "(.*)([a|c])/account/login.html$" /static/login/$1$2/login.html last;
	                                rewrite "(.*)f/user/login.html$" /static/login/$1f/login.html last;
	                                rewrite "(.*)([a|c|f]{1})_[0-9]+/multiple/redirection?(.*)$" /index.php?r=multiple/redirection&shortFlag=$2&$3 last;
	                                rewrite "(.*)([a|c|f]{1})_[0-9]+/multiple/(.*)$" /index.php?r=multiple/$3&shortFlag=$2 last;
	                                rewrite "(.*[a|c])_[0-9]+/index.htm$" /index.php?co=$1&r=backend last;
	                                rewrite "(.*[a|c])/(.*[^html])$" /index.php?co=$1&r=backend/$2 last;
	                                rewrite "(.*[a|c])_[0-9]+/(.*[^html])$" /index.php?co=$1&r=backend/$2 last;
	
	                                rewrite "(.*f)_[0-9]+/index.htm$" /index.php?co=$1&r=frontend last;
	                                rewrite "(.*f)/(.*)$" /index.php?co=$1&r=frontend/$2 last;
	                                rewrite "(.*f)_[0-9]+/(.*)$" /index.php?co=$1&r=frontend/$2 last;
	
	                                rewrite "site/(.*)$" /index.php?&r=site/$1 last;
	   }
	 
	 
	 
	 
	 
	 
	＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝nginx 日志格式
	推荐：
	log_format  access  '$remote_addr - $remote_user [$time_local] "$request" '
	              '$status $body_bytes_sent "$http_referer" '
	              '"$http_user_agent" $http_x_forwarded_for';
	
	218.28.60.30 - - [20/May/2011:15:02:12 +0800] "GET /manager/html HTTP/1.1" 404 168 "-" "Mozilla/3.0 (compatible; Indy Library)" -
	 
	 
	 
	log_format access2 '[$time_local] $remote_addr $status $request_time $body_bytes_sent "$request" "$http_referer"';
	 
	 
	log_format main '$remote_addr - $remote_user [$time_local] ''"$request" $status $bytes_sent ''"$http_referer" "$http_user_agent" ''"$gzip_ratio"';
	 
	log_format download '$remote_addr - $remote_user [$time_local] ''"$request" $status $bytes_sent ''"$http_referer" "$http_user_agent" ''"$http_range" "$sent_http_content_range"';
	 
	 
	 
	=====================每天定时切割nginx日志脚本
	
	vim /usr/local/webserver/nginx/sbin/cut_nginx_log.sh
	#!/bin/bash
	# This script run at 00:00
	
	# The Nginx logs path
	logs_path="/usr/local/webserver/nginx/logs/";
	
	mkdir -p ${logs_path}$(date -d "yesterday" + "%Y")/$(date -d "yesterday" + "%m")/
	mv ${logs_path}access.log ${logs_path}$(date -d "yesterday" + "%Y")/$(date -d "yesterday" + "%m")/access_$(date -d "yesterday" + "%Y%m%d").log
	kill -USR1 'cat /usr/local/webserver/nginx/nginx.pid'
	
	
	
	chown -R www:www cut_nginx_log.sh
	chmod +x cut_nginx_log.sh
	
	
	crontab -e
	00 00 * * * /bin/bash /usr/local/webserver/nginx/sbin/cut_nginx_log.sh
	
	
	#/sbin/service crond restart
	 
	 
	 
	===============================  conf 配置头文件
	 
	 
	user  www www;
	
	worker_processes 1;
	
	error_log  /usr/local/nginx/logs/nginx_error.log  crit;
	
	pid        /usr/local/nginx/logs/nginx.pid;
	
	#Specifies the value for maximum file descriptors that can be opened by this process.
	worker_rlimit_nofile 51200;
	
	events
	        {
	                use epoll;
	                worker_connections 51200;
	        }
	 
	 
	 
	===================================  http核心模块
	 
	 
	user  www www;
	
	worker_processes 8;
	
	error_log  /data/logs/nginx/nginx_error.log  crit;
	
	pid        /usr/local/webserver/nginx/nginx.pid;
	
	#Specifies the value for maximum file descriptors that can be opened by this process.
	worker_rlimit_nofile 65535;
	
	events
	{
	  use epoll;
	  worker_connections 65535;
	}
	
	http
	{
	  include       mime.types;
	  default_type  application/octet-stream;
	
	  charset utf-8;
	
	  server_names_hash_bucket_size 128;
	  client_header_buffer_size 128k;
	  large_client_header_buffers 4 128k;
	  client_max_body_size 8m;  #指令指定允许客户端连接的最大请求实体大小，它出现在请求头部的Content-Length字段。 
	
	  sendfile on;
	  tcp_nopush     on;
	  
	  keepalive_timeout 60;  #参数的第一个值指定了客户端与服务器长连接的超时时间，超过这个时间，服务器将关闭连接。 
	
	  tcp_nodelay on;
	
	  fastcgi_connect_timeout 60;
	  fastcgi_send_timeout 60;
	  fastcgi_read_timeout 60;
	  fastcgi_buffer_size 256k;
	  fastcgi_buffers 8 256k;
	  fastcgi_busy_buffers_size 256k;
	  fastcgi_temp_file_write_size 256k;
	 
	 fastcgi_intercept_errors on;
	 语法：fastcgi_intercept_errors on|off
	默认值：fastcgi_intercept_errors off
	使用字段：http, server, location
	这个指令指定是否传递4xx和5xx错误信息到客户端，或者允许nginx使用error_page处理错误信息。
	你必须明确的在error_page中指定处理方法使这个参数有效，正如Igor所说“如果没有适当的处理方法，nginx不会拦截一个错误，这个错误不会显示自己的默认页面，这里允许通过某些方法拦截错误。
	 
	 
	 
	
	  gzip on;
	  gzip_min_length  1k;
	  gzip_buffers     4 16k;
	  gzip_http_version 1.0;
	  gzip_comp_level 2;
	  gzip_types       text/plain application/x-javascript text/css application/xml;
	  gzip_vary on;
	
	  #limit_zone  crawler  $binary_remote_addr  10m;
	
	log_format  access  '$remote_addr - $remote_user [$time_local] "$request" '
	              '$status $body_bytes_sent "$http_referer" '
	              '"$http_user_agent" $http_x_forwarded_for';
	 
	#upstream member {
	#                       server 192.168.1.203:80;
	#                }
	 
	#include vhost/*.conf;
	 
	－－－－－－－－－－－－－－－－－  server核心模块
	 
	 server
	  {
	    listen       80;
	    server_name  www.***.com ;
	    index index.html index.htm index.php;
	    root  /data/www/***/webroot;
	     location / {
	            index index.php index.html index.htm;
	            if (-f $request_filename) {
	                break;
	            }
	            if (-d $request_filename) {
	                break;
	            }
	             rewrite ^(.+)$ /index.php?q=$1 last;
	
	     }
	 
	     location / {
	            return 404;
	     }
	
	      location ~ .*\.(php|php5)?$
	  {
	      #fastcgi_pass  unix:/tmp/php-cgi.sock;
	      fastcgi_pass  127.0.0.1:9000;
	      fastcgi_index index.php;
	      include fcgi.conf;
	     # rewrite ^(.+)$ index.php?q=$1 last;
	  }
	
	
	    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
	    {
	      access_log off;
	      expires      30d;
	    }
	    location ~ .*\.(js|css)$
	    {
	      access_log off;
	      expires      30d;
	    }
	    #access_log  /data/logs/nginx/binhaixian.access.log  access;
	
	  }
	 
	 
	 
	 
	－－－－－－－－－－－－－－－－FastCGI模块
	 
	    fastcgi_connect_timeout 60;#默认值为60.指定同FastCGI服务器的连接超时时间，这个值不能超过75秒 。
	    fastcgi_send_timeout 300;#指令为上游服务器设置等待一个FastCGI进程的传送数据时间，如果有一些直到它们运行完才有输出的长时间运行的FastCGI进程，那么可以修改这个值，如果你在上游服务器的error log里面发现一些超时错误，那么可以恰当的增加这个值。指令指定请求服务器的超时时间，指完成了2次握手的连接，而不是完整的连接 ，如果在这期间客户端没有进行数据传递，那么服务器将关闭这个连接。
	    fastcgi_read_timeout 300;#默认值为60.前端FastCGI服务器的响应超时时间，如果有一些直到它们运行完才有输出的长时间运行的FastCGI进程，或者在错误日志中出现前端服务器响应超时错误，可能需要调整这个值 。
	     fastcgi_buffer_size 64k;  #这个参数指定将用多大的缓冲区来读取从FastCGI进程到来应答头。默认的缓冲区大小为fastcgi_buffers指令中的每块大小 ，可以将这个值设置更小。   
	 
	    fastcgi_buffers 4 64k;   #这个参数指定了从FastCGI进程到来的应答，本地将用多少和多大的缓冲区读取。
	默认这个参数等于分页大小 ，根据环境的不同可能是4K, 8K或16K。
	#getconf PAGESIZE  得到分页大小,返回的单位为bytes
	4096
	例如fastcgi_buffers 256 4k; # 设置缓冲区大小为4k + 256 * 4k = 1028k。这意味着所有FastCGI返回的应答，nginx将超过1M的部分写入磁盘，1M以内的部分写入内存。
	 
	    fastcgi_busy_buffers_size 128k;
	    fastcgi_temp_file_write_size 128k;
	 
	 
	      fastcgi_pass  127.0.0.1:9000; #指定FastCGI服务器监听端口与地址，可以是本机或者其它
	      fastcgi_index index.php;
	      include fcgi.conf;
	 
	 
	 
	------------------------------------------ location设置优先级
	 
	(location =) > (location 完整路径 >) >(location ^~ 路径) >(location ~* 正则) >(location 路径)
	     只要匹配到，其它的都会忽略，然后返回到改匹配。
	
	
	如果都是正则，都能够匹配，以配置文件出现顺序来，谁在前谁优先。
	 
	 
	------------------------------------------  一个error对应一个slow log
	 
	#php-fpm.log
	May 27 11:50:44. 120263 [ERROR ] fpm_trace_get_long(), line 78: ptrace(PEEKDATA) failed: Input/output error (5)
	 
	 
	#php-fpm-slow.log 
	May 27 11:50:44. 120041 pid 25314 (pool default)
	script_filename = /data/www/***/webroot/index.php
	[0xbf923f60] closedir() /data/www/cakephp/cake/libs/folder.php:191
	[0xbf9241b0] read() /data/www/cakephp/cake/libs/folder.php:465
	[0xbf924610] __tree() /data/www/cakephp/cake/libs/folder.php:441
	[0xbf924c80] tree() /data/www/cakephp/cake/libs/configure.php:1029
	[0xbf9259e0] __find(
	) /data/www/cakephp/cake/libs/configure.php:954
	[0xbf925b60] import() /data/www/***/config/bootstrap.php:52
	[0xbf9263a0] +++ dump failed
	 
	 
	 
	－－－－－－－－－－－－－－nginx 配置 gzip压缩
	 
	一般情况下压缩后的html、css、js、php、jhtml等文件，大小能降至原来的25%，也就是说，原本一个100k的html，压缩后只剩下25k。这无疑能节省很多带宽，也能降低服务器的负载。
	在nginx中配置gzip比较简单
	
	一般情况下只要在nginx.conf的http段中加入下面几行配置即可
	
	引用
	   gzip  on;
	   gzip_min_length  1024;# 设置被压缩的最小请求，单位为bytes。少于这个值大小的请求将不会被压缩，这个值由请求头中的Content-Length字段决定。 建议值为1k;
	   gzip_buffers     4 8k; #指定缓存压缩应答的缓冲区数量和大小，如果不设置，一个缓存区的大小为分页大小，根据环境的不同可能是4k或8k。以8k为单位，按照原始数据大小以8k为单位的4倍申请内存。
	  gzip_http_version 1.0;
	   gzip_types       text/plain application/x-javascript text/css text/html application/xml;#为除“text/html”之外的MIME类型启用压缩，“text/html”总是会被压缩 。
	  gzip_comp_level 2;#指定压缩等级，其值从1到9，1为最小化压缩（处理速度快），9为最大化压缩（处理速度慢）。
	  gzip_vary on;#启用应答头“Vary: Accept-Encoding”，注意，由于一个bug将导致IE 4-6无法缓存内容。
	 
	
	重启nginx
	可以通过网页gzip检测工具来检测网页是否启用了gzip
	http://gzip.zzbaike.com/
	 
	 
	 
	---------------重定向nginx错误页面的方法
	 
	 
	
	error_page 404  /404.html;
	error_page 403  /error.html;
	 
	
	这个404.html保证在nginx主目录下的html目录中即可，如果需要在出现404错误后直接跳转到另外一个地址，可以直接设置如下：
	
	
	error_page 404 http://www.***.net ;
	
	
	同样的方式可以定义常见的403、500等错误。
	
	
	特别注意的是404.html文件页面大小要超过512k，不然会被ie浏览器替换为ie默认的错误页面。
	
	#502 等错误可以用同样的方法来配置。 
	error_page  500 502 503 504 = /50x.html;
	 
	 
	------------------------------虚拟主机配置
	server {
	    listen   80;
	    server_name  localhost; 
	    access_log  /var/log/nginx/localhost.access.log;
	
	    location / {
	        root   /var/www/nginx-default; 
	        index index.php index.html index.htm;
	    }
	
	    location /doc {
	        root   /usr/share;
	        autoindex on;
	        allow 127.0.0.1;
	        deny all;
	    }
	
	    location /images {
	        root   /usr/share;
	        autoindex on;
	    }
	    location ~ \.php$ {
	        fastcgi_pass   127.0.0.1:9000;
	        fastcgi_index  index.php;
	        fastcgi_param  SCRIPT_FILENAME  /var/www/nginx-default$fastcgi_script_name;
	        include /etc/nginx/fastcgi_params;
	    }
	}
	
	
	server {
	    listen   80;
	    server_name  sdsssdf.localhost.com; 
	    access_log  /var/log/nginx/localhost.access.log;
	
	    location / {
	        root   /var/www/nginx-default/console; 
	        index index.php index.html index.htm;
	    }
	
	    location /doc {
	        root   /usr/share;
	        autoindex on;
	        allow 127.0.0.1;
	        deny all;
	    }
	
	    location /images {
	        root   /usr/share;
	        autoindex on;
	    }
	    location ~ \.php$ {
	        fastcgi_pass   127.0.0.1:9000;
	        fastcgi_index  index.php;
	        fastcgi_param  SCRIPT_FILENAME  /var/www/nginx-default$fastcgi_script_name;
	        include /etc/nginx/fastcgi_params;
	    }
	}
	 
	----------------------监控  
	 
	location ~ ^/NginxStatus/ { 
	
	stub_status on; #Nginx 状态监控配置     
	}
	 
	 
	 
	这样通过 http://localhost/NginxStatus/(最后的/不能掉) 监控到 Nginx 的运行信息:
	 
	Active connections: 1 
	server accepts handled requests
	 1 1 5 
	Reading: 0 Writing: 1 Waiting: 0
	 
	 
	NginxStatus 显示的内容意思如下：
	active connections – 当前 Nginx 正处理的活动连接数。
	server accepts handled requests -- 总共处理了 14553819 个连接 , 成功创建 14553819 次握手 ( 证明中间没有失败的 ), 总共处理了 19239266 个请求 ( 平均每次握手处理了 1.3 个数据请求 )。
	reading -- nginx 读取到客户端的 Header 信息数。
	writing -- nginx 返回给客户端的 Header 信息数。
	waiting -- 开启 keep-alive 的情况下，这个值等于 active - (reading + writing)，意思就是 Nginx 已经处理完正在等候下一次请求指令的驻留连接。
	 
	-------------------------------静态文件处理
	通过正则表达式，我们可让 Nginx 识别出各种静态文件
	 
	location ~ \.(htm|html|gif|jpg|jpeg|png|bmp|ico|css|js|txt)$ {
	        root /var/www/nginx-default/html; 
	        access_log off; 
	        expires 24h;
	        }
	 
	 
	 
	    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)?$ 
	    {
	      #root /var/www/ttt/www/static/cache/;
	      access_log off;
	      expires      30d;
	    }
	
	    location ~ .*\.(js|css|html)?$ 
	    {
	      #root /var/www/ttt/www/static/cache/;
	      access_log off;
	      expires 7d;
	    }
	 
	对于例如图片、静态 HTML 文件、js 脚本文件和 css 样式文件等，我们希望 Nginx 直接处理并返回给浏览器，这样可以大大的加快网页浏览时的速度。因此对于这类文件我们需要通过 root 指令来指定文件的存放路径 ，同时因为这类文件并不常修改，通过 expires 指令来控制其在浏览器的缓存，以减少不必要的请求。 expires 指令可以控制 HTTP 应答中的“ Expires ”和“ Cache-Control ”的头标（起到控制页面缓存的作用）。您可以使用例如以下的格式来书写 Expires：
	 
	 
	 
	 
	 
	 
	expires 1 January, 1970, 00:00:01 GMT;
	expires 60s;
	expires 30m;
	expires 24h;
	expires 1d;
	expires max;
	expires off;
	 
	 
	这样当你输入http://192.168.200.100/1.html的时候会自动跳转到var/www/nginx-default/html/1.html
	 
	例如 images 路径下的所有请求可以写为：
	 
	 
	 
	 
	 
	 
	location ~ ^/images/ {
	    root /opt/webapp/images;
	}
	 
	 
	 
	 
	------------------------动态页面请求处理[集群]
	Nginx 本身并不支持现在流行的 JSP、ASP、PHP、PERL 等动态页面，但是它可以通过反向代理将请求发送到后端的服务器，例如 Tomcat、Apache、IIS 等来完成动态页面的请求处理。前面的配置示例中，我们首先定义了由 Nginx 直接处理的一些静态文件请求后，其他所有的请求通过 proxy_pass 指令传送给后端的服务器 （在上述例子中是 Tomcat）。最简单的 proxy_pass 用法如下：
	 
	location / {
	    proxy_pass        http://localhost:8080;
	    proxy_set_header  X-Real-IP  $remote_addr;
	}
	 
	 
	这里我们没有使用到集群，而是将请求直接送到运行在 8080 端口的 Tomcat 服务上来完成类似 JSP 和 Servlet 的请求处理。
	当页面的访问量非常大的时候，往往需要多个应用服务器来共同承担动态页面的执行操作，这时我们就需要使用集群的架构。 Nginx 通过 upstream 指令来定义一个服务器的集群，最前面那个完整的例子中我们定义了一个名为 tomcats 的集群，这个集群中包括了三台服务器共 6 个 Tomcat 服务。而 proxy_pass 指令的写法变成了：
	 
	 
	 
	# 集群中的所有后台服务器的配置信息
	    upstream tomcats { 
	     server 192.168.0.11:8080 weight=10; 
	     server 192.168.0.11:8081 weight=10; 
	     server 192.168.0.12:8080 weight=10; 
	     server 192.168.0.12:8081 weight=10; 
	     server 192.168.0.13:8080 weight=10; 
	     server 192.168.0.13:8081 weight=10; 
	    } 
	    location / { 
	        proxy_pass http://tomcats;# 反向代理
	        include proxy.conf; 
	        }
	 
	 
	----------------------压力测试
	wget http://blog.s135.com/soft/linux/webbench/webbench-1.5.tar.gz   
	tar zxvf webbench-1.5.tar.gz   
	cd webbench-1.5   
	make && make install
	#webbench -c 100 -t 10 http://192.168.200.100/info.php
	参数说明：-c表示并发数，-t表示持续时间(秒)
	 
	 
	root@ubuntu-desktop:/etc/nginx/sites-available# webbench -c 100 -t 10 http://192.168.200.100/info.php
	Webbench - Simple Web Benchmark 1.5
	Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.
	
	Benchmarking: GET http://192.168.200.100/info.php
	100 clients, running 10 sec.
	
	Speed=19032 pages/min, 18074373 bytes/sec.
	Requests: 3172 susceed, 0 failed.
	 
	 
	 
	 
	 
	－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－PPC提供nginx详细配置说明
	 
	
	#运行用户
	user  nobody nobody;
	#启动进程
	worker_processes  2;
	#全局错误日志及PID文件
	error_log  logs/error.log notice;
	pid        logs/nginx.pid;
	#工作模式及连接数上限
	events{use epoll;
	worker_connections      1024;}#设定http服务器，利用它的反向代理功能提供负载均衡支持
	
	
	http{#设定mime类型
	            include      conf/mime.types;
	            default_type  application/octet-stream;
	            #设定日志格式
	            log_format main'$remote_addr - $remote_user [$time_local] ''"$request" $status $bytes_sent ''"$http_referer" "$http_user_agent" ''"$gzip_ratio"';
	            log_format download'$remote_addr - $remote_user [$time_local] ''"$request" $status $bytes_sent ''"$http_referer" "$http_user_agent" ''"$http_range" "$sent_http_content_range"';
	            #设定请求缓冲
	            client_header_buffer_size    1k;
	            large_client_header_buffers  4 4k;
	            
	            #开启gzip模块
	            gzip on;
	            gzip_min_length  1100;
	            gzip_buffers    4 8k;
	            gzip_types      text/plain;
	            output_buffers  1 32k;
	            postpone_output  1460; 
	            
	            #设定access log
	            access_log  logs/access.log  main;
	            client_header_timeout  3m;
	            client_body_timeout    3m;
	            send_timeout          3m;
	            sendfile                on;
	            tcp_nopush              on;
	            tcp_nodelay            on;
	            keepalive_timeout  65;
	            
	            #设定负载均衡的服务器列表
	            upstream mysvr{#weigth参数表示权值，权值越高被分配到的几率越大
	                        #本机上的Squid开启3128端口
	                        server 192.168.8.1:3128 weight=5;
	                        server 192.168.8.2:80  weight=1;
	                        server 192.168.8.3:80  weight=6;
	            } 
	            
	            #设定虚拟主机
	            server{listen          80;
	                        server_name    192.168.8.1 www.okpython.com;
	                        charset gb2312;
	                        #设定本虚拟主机的访问日志
	                        access_log  logs/www.yejr.com.access.log  main;
	                        #如果访问 /img/*, /js/*, /css/* 资源，则直接取本地文件，不通过squid
	                        #如果这些文件较多，不推荐这种方式，因为通过squid的缓存效果更好
	                        location ~ ^/(img|js|css)/  {
	                                    root    /data3/Html;
	                                    expires 24h;
	                        } 
	                        #对 "/" 启用负载均衡 
	                        location / {
	                                    proxy_pass      http://mysvr; 
	                                    proxy_redirect          off;
	                                    proxy_set_header        Host $host;
	                                    proxy_set_header        X-Real-IP $remote_addr;
	                                    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
	                                    client_max_body_size    10m;
	                                    client_body_buffer_size 128k;
	                                    proxy_connect_timeout  90;
	                                    proxy_send_timeout      90;
	                                    proxy_read_timeout      90;
	                                    proxy_buffer_size      4k;
	                                    proxy_buffers          4 32k;
	                                    proxy_busy_buffers_size 64k;
	                                    proxy_temp_file_write_size 64k;
	                        }
	                        #设定查看Nginx状态的地址
	                        location /NginxStatus {
	                                    stub_status            on;
	                                    access_log              on;
	                                    auth_basic              "NginxStatus";
	                                    auth_basic_user_file  conf/htpasswd;   ＃conf/htpasswd 文件的内容用 apache 提供的 htpasswd 工具来产生即可 
	                  }
	      }
	}
	 