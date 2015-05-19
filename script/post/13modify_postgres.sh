#!/bin/sh
#****************************************************************#
# ScriptName: 13modify_postgres.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2013-04-12 13:49
# Modify Author: $liujmsunits@hotmail.com
# Modify Date: 2015-05-06 01:23
# Function: 
#***************************************************************#
function init_app(){
	mkdir /root/.ssh
	cat ${DIR}/conman/conman/system/root.id_rsa.pub > /root/.ssh/authorized_keys
	useradd -g 2000 -u 2000 admin
	useradd admin
	mkdir -p /home/admin/.ssh/
	cat ${DIR}/conman/conman/system/admin.id_rsa.pub > /home/admin/.ssh/authorized_keys
	chown admin.admin  /home/admin/.ssh/authorized_keys
	grouplist="
	users:100
	logs:1338
	ads:1685
	"
	for i in $grouplist;do
		gid=`echo $i|cut -d ':' -f2`
		group=`echo $i|cut -d ':' -f1`
		groupadd -g $gid $group;
	done
}


function console_init(){
	cp ${DIR}/conman/system/root.id_rsa /root/.ssh/id_rsa
	cp ${DIR}/conman/system/root.id_rsa.pub /root/.ssh/id_rsa.pub
#	cp ${DIR}/conman/system/admin.id_rsa /home/admin/.ssh/id_rsa
#	cp ${DIR}/conman/system/admin.id_rsa.pub /home/admin/.ssh/id_rsa.pub
	cp -r ${DIR}/conman/system/config/console/homeadminbin /home/admin/bin
#	cp -pf ${DIR}/conman/system/config/console/bash/admin/.bashrc /home/admin/
#	cp -pf ${DIR}/conman/system/config/console/bash/admin/.bash_profile /home/admin/
#	cp -pf ${DIR}/conman/system/config/console/bash/root/.bashrc /root/
#	cp -pf ${DIR}/conman/system/config/console/bash/root/.bash_profile /root/
	chown root:root /root/.bash*
	chown -R  admin:admin  /home/admin
	mkdir /root/bin
	cp ${DIR}/conman/system/config/console/bin/*  /root/bin/
	
	for i in cache home lvs log;do
	n=`cat /etc/hosts|grep $i|awk '{print $2}'|tr '\n' ' '`
	sed -i "s#@$i@#$n#g" /home/admin/bin/gethost.sh;
	done

	if [[ $HOST = console1* ]];then
		RIP=$RIP1
	else
		RIP=$RIP2
	fi
	cat <<- EOF > /etc/sysconfig/network-scripts/ifcfg-$ETHOOB
	DEVICE=$ETHOOB
	BOOTPROTO=none
	IPADDR=$RIP
	NETMASK=255.255.255.0
	ONBOOT=yes
	USERCTL=no
	EOF

	rpm -ihv "http://${KS}:9999/ksis/software/nmap-5.21-4.el6.x86_64.rpm"
}
function create_hostf()
{
	    /home/admin/bin/gethost.sh allhost | sed "s/ /\n/g" > /root/allhost
		/home/admin/bin/gethost.sh image | sed "s/ /\n/g" > /root/image
		/home/admin/bin/gethost.sh lvs | sed "s/ /\n/g" > /root/lvs
		/home/admin/bin/gethost.sh homehost | sed "s/ /\n/g" > /root/homehost
		/home/admin/bin/gethost.sh kunlun | sed "s/ /\n/g" > /root/kunlun
}

AN=`lspci | grep -i net|wc -l`
ANN=$[AN-1]
i=0
TE=0
while [ $i -le $ANN ]
do
        if ifconman/system/config eth$i >/dev/null;then
                if ethtool -i eth$i|grep ixg;then
                        TE=$[TE+1]
                fi
        fi
        i=$[$i+1]
done
GE=$[AN-TE]
GEN=$[GE-1]

HOST=$ALHN
if [ $TE != "0" ];then
ETHOOB="eth"$TE
else
ETHOOB=eth1
fi

RIP1=`echo $OOB|awk -F'.' '{print $1"."$2"."$3".251"}'`
RIP2=`echo $OOB|awk -F'.' '{print $1"."$2"."$3".252"}'`
init_app

if [[ $VHOSTNAME = console* ]];then
	console_init
	create_hostf
fi
