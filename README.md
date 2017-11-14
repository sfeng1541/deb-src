# deb-src
Ubuntu 16.04下与apt离线源有关的自动化shell脚本试验

1 概述
没有网络连接的机器重装操作系统之后，需要在机器本地架设离线源，以能够使用apt/apt-get/dpkg命令安装所需软件。大致步骤为，先在具备网络连接的干净机器上进行一遍软件安装，获取所需deb文件，生成离线源并打包拷贝。解包到未联网机器，配置离线源，进行安装。如以后会拷贝部分deb文件到未联网机器的离线源目录树，进行软件版本更新，还需要将离线源本地化。将这些操作写入shell和expect脚本，方便以后操作。

2 具体说明
<1> 在连接外网的机器上生成离线源
<1.1> 在指定位置为离线源生成目录树
      ./create-tree.sh -p /var/debian-dev/
<1.2> 将系统中已缓存的deb文件拷入离线源目录树
      ./cp-deb.sh -p /var/debian-dev/
<1.3> 在系统中创建gpg密钥，用户名和密码由-g参数指定。并生成对应的keyFile
      ./genkey-auto.sh -g myname -p /var/debian-dev/
<1.4> 生成离线源所需的Packages和Release文件
      ./release-auto.sh -g myname -p /var/debian-dev/
(已被总结进src-gen.sh，并包含了打包操作，在当前目录生成debian-dev.tar.gz文件)

<2> 在未联网机器上使用离线源
<2.1> 确保离线源目录树中的目录链接正常
      ./dists-ln.sh -p /var/debian-dev/
<2.2> 配置使用离线源
      ./apt.sh -vc -g myname -p /var/debian-dev/
(已被总结进src-use.sh，并前置了解包操作，会首先在当前目录下解开debian.tar.gz文件)

<3> 在未联网机器上，进行离线源本地化
<3.1> 删除<2.2>中注册的，对应联网机器的keyFile
      ./apt-key-del.sh -g myname
<3.2> 创建本机的gpg密钥，用户名和密码由-g参数指定。并生成对应的keyFile
      ./genkey-auto.sh -g myname -p /var/debian-dev/
<3.3> 重新生成一遍离线源所需的Packages和Release文件
      ./release-auto.sh -g myname -p /var/debian-dev/
<3.4> 注册新的keyFile文件
      apt-key add /var/debian-dev/keyFile
      apt-get update
<3.5> 之后每次拷入新deb文件，执行一遍
      ./release-auto.sh -g myname -p /var/debian-dev/
      apt-get update
      即可
(3.1至3.4已被总结进src-local.sh)

注意：
* 上述说明中，每个脚本的-g和-p参数给出的值都为缺省值，省略也可以。比如<1.3>，直接使用./genkey-auto.sh即可。
* -p参数的路径必须以/结尾。
* 需要用root用户执行所有的脚本。

3 脚本试验(假设参数不使用缺省值)
<1> 联网情况下
    ./src-gen.sh -g gpgtestname -p /var/deb-src/
    此时离线源已打包好，当前的脚本文件目录中的debian-dev.tar.gz包含了本机所有已缓存的deb包。
<2> 如使用同一台机器做后续试验，使用脚本
    ./gpg-del-key.exp gpgtestname
    删除gpg密钥。相当于已经换了一台机器。
    断开网络连接，然后
    ./src-use.sh -g gpgtestname -p /var/deb-src/
    现在可以使用apt-get install等命令进行离线安装了。
<3> ./src-local.sh -g gpgtestname -p /var/deb-src/
    完成离线源本地化。
<4> 结束试验
    ./apt-key-del.sh -g gpgtestname
    ./gpg-del-key.exp gpgtestname
    然后删除/var/deb-src/文件夹，和脚本文件目录里的debian-dev.tar.gz。清除完毕。

