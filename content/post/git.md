+++
date = "2016-12-20T10:44:55+08:00"
draft = false
title = "git"
tags = [
  "framework"
]

+++


### 使.gitignore生效

    git rm -r --cached .
    git add .
    git commit -m ".gitignore is now working"






### git 和 svn 的区别

分布式与集中式，git 有本地版本库，svn 较大依赖于远程版本库，在没有网或服务器出问题的情况下，只能修改，无法进行更新和提交。
分布式版本控制系统 （ Distributed Version Control System，简称 DVCS ）

集中式版本控制系统（ Centralized Version Control Systems，简称 CVCS ）

###  检入 检出 导入 导出

受控制，被索引连接的文件的拉取，推送操作，叫做检出，检入。
无关联，纯文件的操作叫导入，导出。

### .git文件夹解析

hooks: 存放一些shell脚本   .sample扩展名 是没有引用   的，去除 .sample 可以写一些在执行git 命令之    后调用的脚本，比如同服务器自动项目部署。

info:目录保存了一份不希望在 .gitignore 文件中管理的全局可执行文件。
logs:保存所有更新的引用记录
objects:该目录存放所有的Git对象
refs:具体的引用.

COMMIT_EDITMSG:上次提交信息.
config:文件包含了项目特有的配置选项.
description:仅供 GitWeb 程序使用.

HEAD:当前分支引用.
index:暂存区信息（二进制文件）

packed-refs:pack文件信息的引用.
git对象连接图--四个对象

blob(内容)  tree(文件目录及连接文件名) commit(指向一个tree，保存提交信息，作者) tag(标签，指向commit)


###git 常用命令 --- 创建，拉取他人或远程仓库代码

两种方法生成和获取版本库，

1. git init

    本地生成，之后添加远程链接，连接到远程版本库

    git remote -v 查看远程仓库链接

    git remote add 远程仓库名 远程链接

        eg: git remote add origin git@github.com:ruushwei/testgit.git


    链接如果用https ，可以添加用户名和密码到url，以后操作不用输入用户密码

        eg: git remote add origin https://ruushwei:zhw15128473081@github.com/ruushwei/testgit.git

2. git clone git://github.com/schacon/simplegit.git 别名
添加代码

git add .      //添加当前目录及其下所有文件到暂存区，待commit

git add *     //添加当前目录所有文件

git add 文件名  //添加文件
工作区，暂存区，日志 转换关系图



###git reset

--mixed： 暂存区恢复原样，工作目录修改不变。(add 了 想反悔)

--soft：暂存区和工作区返回commit之前 。(commit 了想反悔)

--hard：让暂存区和工作区都回到上个commit的时候。 (老子就不应该改)

git reset HEAD file     //使暂存区该文件恢复上一版本

git reset HEAD^      //使暂存区恢复上一版本

git reset {sha1哈希码}   // 此哈希值可以从 git log 的  commit 信息中获取


//恢复工作区文件，加上 --hard

git reset --hard origin/master      //与远程仓库版本一致

git reset --hard {commit版本号}   //使工作区回复到某一版本
git rm

git rm 会将条目从缓存区中移除。这与 git reset HEAD 将条目取消缓存是有区别的。

“取消缓存”的意思就是将缓存区恢复为我们做出修改之前的样子。

 在另一方面，git rm 则将该文件彻底从缓存区踢出，因此它不再下一个提交快照之内，

进而有效地删除它。

.gitignore 生效时使用该命令
git log

git log      查看当前分支 指向的commit 及其之前的信息,一个链表

git reflog  查看所有分支 所有信息 ， 即使是回退版本之前的信息
.gitignore文件 忽略规则

###常用的规则：

target*

.idea*        

 *~


以上相关文件不会被 add


* 修改 .gitignore文件，若想忽略的文件已经在版本库中，在repo的根目录下运行：


    git rm -r --cached .
    git add .

再进行提交，重新经过.gitignore过滤

###git branch

git branch 分支名               //创建分支

git branch                 //查看本地分支  

git branch -r             //查看远程分支 ，fetch 之后会有远程分支

git branch -a            //查看全部分支


git branch -d  分支名  // 删除分支


git checkout 分支名      //切换分支 

git checkout -b 分支名         //先生成新分支，再切换
工作目录跟随分支切换而改变
git commit

git commit -m  “提交信息”


git commit -a -m  “提交信息”

提交已追踪的信息，相当于 
git add 已追踪文件 + 
git commit -m 
git push

git push 远程名 分支名


    eg: git push origin master
git fetch -- git pull

git pull 远程名 分支名

    eg: git pull origin master

git pull origin master ==  git fetch origin master  + git merge origin/master



git diff master..origin/master     //查看本地分支与远程分支区别,如果是你自己本地修改的，肯定会与远程版本不一样，忽略即可，不会冲突。


推荐先git fetch ，git diff 查看区别，再决定是否进行合并。
git diff

git diff           // 写入暂存区的文件和工作区文件的区别。

  *查看冲突文件时用到，很方便。


git diff --cached       //当前暂存区版本与上一个commit 版本的区别


  *即将提交的和上一个版本的区别

git diff HEAD           //工作区与上一次提交的区别

  *工作区整体与上个版本的区别
###git tag

git tag -a v1.0                  //为当前版本加标签

git tag -a v0.9 558151a    //为某版本追加标签.

git tag -a v1.4 -m 'my version 1.4'   // -m 添加附注信息



git show 命令查看相应标签的版本信息，并连同显示打标签时的提交对象

git show v1.0
git merge 分支名

当两个分支 改了同一个位置的时候，会产生冲突，文件中会出现和svn 差不多的两个版本的标记。

HEAD 为你当前分支的版本，另一个为合并分支版本

从远程拉代码，实际就是git fetch 在本地生成分支  远程名/分支名  

eg:origin/master

可以 git branch -a 或 -r 看到远程分支

再git merge 进行合并，执行的与本地分支合并是一个命令

修改后 git commit -m  提交新版本，继续开发或推送到远程仓库。


###svn 迁移到 git

svn 项目迁移到 github 等 git服务器 , 以下操作均在客户端进行


1.  做用户映射文件，user.txt  , 内容如下

    hongwei=hongwei.zhang<377546584@qq.com>

    svn用户名=git用户名<邮箱>

    非必须，在commit的时候添加作者信息时使用，在log中显示


2. 克隆 svn 库

    git svn clone <svn repo url> --no-metadata -A users.txt -t tags -b branches -T 

    trunk <destination dir name>


    --no-metadata 去除 svn 附带信息

    -A  author 作者信息文件

    -t   tags 文件夹

    -b   分支文件夹

    -T   主文件夹


3. 转换分支     branch->branch    branch -> tag 


    新建分支，将svn 生成的远程分支 merge 到新分支上



    svn 的 tag 都变成了 branch

      恢复tag

    git tag tag名 远程分支名


4. 连接远程git 服务器，提交代码


    github 或 coding 上新建仓库，得到远程链接


    git remote add {url}


    在分支push到远程  git push origin master


    远程会新建分支，存储信息。

