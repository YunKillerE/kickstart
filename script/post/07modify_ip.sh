#!/bin/bash
#****************************************************************#
# ScriptName: modify_ip.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2012-05-29 15:59
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-30 03:02
# Function: 
#***************************************************************#
function cal_network()
{
    netmask=$NETMASK
    ip1=`echo $ip|awk -F'.' '{print $1}'`
    ip2=`echo $ip|awk -F'.' '{print $2}'`
    ip3=`echo $ip|awk -F'.' '{print $3}'`
    ip4=`echo $ip|awk -F'.' '{print $4}'`
    netmask1=`echo $netmask|awk -F'.' '{print $1}'`
    netmask2=`echo $netmask|awk -F'.' '{print $2}'`
    netmask3=`echo $netmask|awk -F'.' '{print $3}'`
    netmask4=`echo $netmask|awk -F'.' '{print $4}'`
    let "network1=$ip1 & $netmask1"
    let "network2=$ip2 & $netmask2"
    let "network3=$ip3 & $netmask3"
    let "network4=$ip4 & $netmask4"
    let "broadcast1=$ip1 | ~$netmask1"
    let "broadcast2=$ip2 | ~$netmask2"
    let "broadcast3=$ip3 | ~$netmask3"
    let "broadcast4=$ip4 | ~$netmask4"
    broadcast1=` expr $broadcast1 + 256 `
    broadcast2=` expr $broadcast2 + 256 `
    broadcast3=` expr $broadcast3 + 256 `
    broadcast4=` expr $broadcast4 + 256 `
    broadcast="$broadcast1.$broadcast2.$broadcast3.$broadcast4"
    network="$network1.$network2.$network3.$network4"
    gateway4=`expr $broadcast4 - 1`
    gateway="$network1.$network2.$broadcast3.$gateway4"
    GATEWAY="$gateway"
    sed -i "s/GATEWAY=.*/GATEWAY=$GATEWAY/" /root/$JIMMYSN
}

function create_nobond(){
	cat <<- EOF > /etc/sysconfig/network-scripts/ifcfg-$ETH0
	DEVICE=$ETH0
	#HWADDR=$ETH0_MAC
	BOOTPROTO="static"
	TYPE="Ethernet"
	IPADDR=$IPADDR
	NETMASK=$NETMASK
	ONBOOT=yes
	EOF

}

function create_bond(){
	echo "alias bond0 bonding" >/etc/modprobe.d/bonding.conf
	cat <<- EOF >/etc/sysconfig/network-scripts/ifcfg-$ETH0
	DEVICE=$ETH0
	HWADDR=$ETH0_MAC
	BOOTPROTO=none
	TYPE="Ethernet"
	ONBOOT=yes
	MASTER=bond0
	SLAVE=yes
	EOF

	cat <<- EOF > /etc/sysconfig/network-scripts/ifcfg-$ETH1
	DEVICE=$ETH1
	HWADDR=$ETH1_MAC
	BOOTPROTO=none
	TYPE="Ethernet"
	ONBOOT=yes
	MASTER=bond0
	SLAVE=yes
	EOF

	cat <<- EOF > /etc/sysconfig/network-scripts/ifcfg-bond0
	DEVICE="bond0"
	BOOTPROTO="static"
	ONBOOT="yes"
	TYPE="ethernet"
	IPADDR=$IPADDR
	NETMASK=$NETMASK
	EOF
	echo "PEERDNS=no" >>/etc/sysconfig/network-scripts/ifcfg-bond0
	if echo $NETMOD|grep "mode4";then
		echo "BONDING_OPTS=\"miimon=100 mode=4 xmit_hash_policy=2\"" >>/etc/sysconfig/network-scripts/ifcfg-bond0
	elif echo $NETMOD|grep "mode0";then
		echo "BONDING_OPTS=\"miimon=100 mode=0\"" >>/etc/sysconfig/network-scripts/ifcfg-bond0
	else
		echo "BONDING_OPTS=\"miimon=100 mode=1 updelay=600000 primary=$ETH0\"" >>/etc/sysconfig/network-scripts/ifcfg-bond0
	fi
	wget -T3 -t2 -O /etc/init.d/changeDevice http://${KS}:9999/ngis/download/changeDevice &>/dev/null
	chmod +x /etc/init.d/changeDevice
	chkconfig changeDevice on
	
}


function create_lo()
{
	for i in $(eval echo {0..$1}); do
		eval ip="\$VIP${i}"
		cat <<- EOF >/etc/sysconfig/network-scripts/ifcfg-lo:$i
		DEVICE=lo:$i
		IPADDR=$ip
		NETMASK=255.255.255.255
		NETWORK=$ip
		BROADCAST=$ip
		ONBOOT=yes
		NAME=loopback
		EOF
	cat /etc/sysconfig/network-scripts/ifcfg-lo:$i
	done
}

	rm -rf /etc/sysconfig/network-scripts/ifcfg-eth{0,1,2,3,4,5,7,8,9}
	
	if [  "X$NETMOD" = "XNOBOND" -o  "X$NETMOD" = "X" ];then
		create_nobond
	else
		create_bond
	fi
	if  [ "$HOSTTAG" = "cache_server" -o "$HOSTTAG" = "*cache_server" ];then
	    	VIP0=$IVIP1
		VIP1=$IVIP2
		create_lo 1
	elif [ "$HOSTTAG" = "home_server" -o "$HOSTTAG" = "*home_server" ];then
		VIP0=$WVIP1
		VIP1=$WVIP2
		VIP2=$WVIP3
		VIP3=$WVIP4
		VIP4=$WVIP5
		VIP5=$WVIP6
		create_lo 5
	fi
    cat <<- EOF > /etc/sysconfig/network
	NETWORKING="yes"
	HOSTNAME="${VHOSTNAME}"
	GATEWAY="${GATEWAY}"
	EOF

echo "MODIFY_IP_FLAG"

cat /etc/sysconfig/network
cat /etc/sysconfig/network-scripts/ifcfg-$ETH0
cat /etc/sysconfig/network-scripts/ifcfg-bond0
cat /etc/resolv.conf
cat /etc/hosts
