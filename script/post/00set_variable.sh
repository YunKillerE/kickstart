#!/bin/bash
#****************************************************************#
# ScriptName: 00set_variable.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-05-05 04:51
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-30 02:47
# Function: get veriable
#***************************************************************#
DIR="/mnt/temp"

[ "$JIMMYSN" == "" ]&&JIMMYSN=`/usr/sbin/dmidecode -s system-serial-number|grep -v '^#'|sed 's/ //g'`
DHCPIP=`/sbin/ifconfig | grep "inet addr"| grep -v "127.0.0.1"| grep -v "255.255.255.255" |awk '{print $2}'| awk -F":" '{print $2}'|sed -n '1p'`JMHOSTNAME=`cat $DIR/nfs/sn2hosts |grep $JIMMYSN |awk '{print  $2}'`
VHOSTNAME=`cat $DIR/nfs/sn2hosts |grep $JIMMYSN |awk '{print  $2}'`
OOB=`cat $DIR/nfs/sn2hosts |grep $JIMMYSN |awk '{print  $NF}'`

ETH0=`cat $DIR/nfs/node |grep ETH0 |awk -F'=' '{print $2}'`
ETH1=`cat $DIR/nfs/node |grep ETH1 |awk -F'=' '{print $2}'`
MAC_ETH0=`ifconfig $ETH0|grep 'HWaddr'|head -n1|grep  -P -o '([0-9A-F]{2}:){5}[0-9A-F]{2}'`
MAC_ETH1=`ifconfig $ETH1|grep 'HWaddr'|head -n1|grep  -P -o '([0-9A-F]{2}:){5}[0-9A-F]{2}'`

IPADDR=`cat $DIR/nfs/sn2hosts |grep $JIMMYSN |awk '{print  $3}'`
NETMASK=`cat $DIR/nfs/node |grep NETMASK |awk -F'=' '{print $2}'`
GATEWAY=`cat $DIR/nfs/node |grep GATEWAY |awk -F'=' '{print $2}'`
NETMOD=`cat $DIR/nfs/sn2hosts |grep $JIMMYSN |awk '{print  $5}'`

KS=`cat $DIR/nfs/node |grep KS |awk -F'=' '{print $2}'`

if [ "$JMHOSTNAME" = "cache*" ]
then
	HOSTTAG="cache_server"
elif 
	[ "$JMHOSTNAME" = "home*" ]
then
	HOSTTAG="home_server"
else
	HOSTTAG=""
fi

touch /root/post/$JIMMYSN

echo "JIMMYSN=$JIMMYSN" >/root/post/$JIMMYSN
echo "NETMASK=$NETMASK" >>/root/post/$JIMMYSN
echo "IPADDR=$IPADDR" >>/root/post/$JIMMYSN
echo "GATEWAY=$GATEWAY" >>/root/post/$JIMMYSN
echo "ETH0=$ETH0" >>/root/post/$JIMMYSN
echo "MAC_ETH0=$MAC_ETH0" >>/root/post/$JIMMYSN
echo "KS=$KS" >>/root/post/$JIMMYSN
echo "OOB=$OOB" >>/root/post/$JIMMYSN
echo "VHOSTNAME=$VHOSTNAME" >>/root/post/$JIMMYSN
echo "NETMOD=$NETMOD" >>/root/post/$JIMMYSN
echo "HOSTTAG=$HOSTTAG" >>/root/post/$JIMMYSN
