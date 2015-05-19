# ksis
RedHat kickstart方式自动安装系统，post脚本自动进行系统初始化配置


主要目录介绍：

1，script   post脚本存放目录，可以在里面的post目录方便地加入自定义脚本，以0-99的数字开头就ok

2，ksis.sh  pxe环境初始化脚本，安装配置httpd、nfs、xinetd、dhcpd、tftp服务

3，iso      redhat/centos镜像挂载目录或者是直接将镜像中的所有文件拷贝到iso文件夹中

4，software 软件存放目录，post脚本需要用到的软件都存放在这个文件夹里

5，command  配置文件存放目录

6，tftpboot tftp目录，pxe引导目录

7，ks       ks文件存放目录，这里只使用了base.ks一个ks文件

8，pre      不同主机应用所安装不同的软件包




使用前的准备：

1，base.ks文件中的%pre脚本，修改你自己的主机名，不同主机名安装不同的软件包，还有在pre文件夹中创建相应的安装包内容文件

2，挂载iso

3，修改script目录下post下面的修改，删除不需要的脚本，增加你自定义的内容

使用方法：

1，编辑nfs/sn2hosts文件，格式如下：

序列号                     主机名         IP          网卡绑定  盘名      OOB IP
                
VMware-564dc690e09bf749   console1   192.168.218.199  NOBOND  /dev/sda  10.121.228.116

这个很重要，ks文件中%pre shell会调用这个脚本来确定不同主机名安装不同的软件包，当然也可以实现不同的分区（后续），
%post shell会调用这个文件来配置主机名、ip、OOB等

2，执行ksis.sh进行本机的pxe环境初始化，如果有服务启动失败，手动查找原因

3，其他机器开机网络启动测试




整体脚本执行流程：

1，pxe启动安装系统

2，ks文件中%pre会判断不同主机安装不同的软件包

3，安装完后post脚本run.sh，系统启动后会执行

4，run.sh脚本会下载post.tgz，解压并执行ksis_post.sh脚本

5，ksis_post.sh脚本会调用执行post目录下0-99开头的脚本
