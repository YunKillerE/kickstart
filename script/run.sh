set -x
#!/bin/sh
#****************************************************************#
# ScriptName: run.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-4-20
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-05 04:22
# Function: wget script and create veriable
#***************************************************************#
path="/mnt/temp/"
pxe_mac=`ifconfig|grep 'HWaddr'|head -n1|grep  -P -o '([0-9A-F]{2}:){5}[0-9A-F]{2}'`
tmp_sn=`dmidecode -s system-serial-number|grep -v '^#'|sed 's/ //g'`
hostname "KSIS-$tmp_sn"
KS=`cat $path/nfs/node |grep KS |awk -F'=' '{print $2}'`
ETH0=`cat $path/nfs/node |grep ETH0 |awk -F'=' '{print $2}'`
ETH1=`cat $path/nfs/node |grep ETH1 |awk -F'=' '{print $2}'`

/etc/init.d/ntpd stop
if ntpdate 110.75.12.74;then
	    hwclock -w
elif ntpdate $KS;then
	    hwclock -w
fi

if ping -c2 -w4 $KS >/dev/null;then
    :
else
    /sbin/ifup $ETH0
fi

#DHCPIP=`/sbin/ifconfig $ETH | grep "inet addr"| grep -v "127.0.0.1"| grep -v "255.255.255.255" |awk '{print $2}'| awk -F":" '{print $2}'`
rm -rf /root/post
mkdir /root/post/
/usr/bin/wget -T3 -t2 http://$KS:9999/ksis/script/post.tgz -O /root/post/post.tgz
cd /root/post/
tar -xzf post.tgz
yum clean all

#echo $KS>>/root/post/ksis_post.log
#echo $DHCPIP>>/root/post/ksis_post.log
#echo $ETH>>/root/post/ksis_post.log
#echo $tmp_sn>>/root/post/ksis_post.log


bash -x /root/post/ksis_post.sh 2>&1 |tee -a /root/post/run.log
