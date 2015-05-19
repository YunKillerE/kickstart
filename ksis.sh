#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear                                                                                           
echo ""
echo -e "\033[7m"
echo "+---------------------------------------------------------------------+"    
echo "+                                                                     +"    
echo "+          JIMMY 克隆系统部署 V0.1 Test Vension                       +"  
echo "+               Platform: Linux                                       +"    
echo "+               2015-05-06                                            +"    
echo "+---------------------------------------------------------------------+"
echo -e "\033[0m"
echo
PWD=`pwd`
usage()
{
echo "Usage: please use it like [ $0 172.16.3.1/24 ]"
exit 1
}
init()
{
  echo ""
  echo ""
  echo "请输入IP段（如：125.39.87.0/25）:"
  read -p "(Default: $IPPOOL):" temp
  if [ "$temp" != "" ]; then
    IPPOOL=$temp
    echo $IPPOOL | egrep -q '[/|.]' || { usage; }
  fi
  echo ""
  echo "请输入KS主机IP（如：10.120.8.251）:"
  read -p "(Default: $KS):" temp
  if [ "$temp" != "" ]; then
    KS=$temp
  fi
  
  echo "请输入当地DNS（如：8.8.8.8）:"
  read -p "(Default ip: 8.8.8.8):" temp
  if [ "$temp" != "" ]; then
    DNS=$temp
  else
    DNS="8.8.8.8"
  fi
  echo "Do you want to add more DNS name? (y/n)"
  read add_more_dns

  if [ "$add_more_dns" == 'y' ]; then

	    echo "Type nameserver,example(114.114.114.114):"
		read DNS1
	    echo "==========================="
		echo moredns list="$DNS1"
		echo "==========================="
	fi
	if [ "X$DNS1" == "X" ]; then
		    DNS1="114.114.114.114"
	else
			:
	fi
  
 }
 
 
function cal_ip(){
ip=$1
NETMASK=`ipcalc -m $ip|awk -F= '{print $2}'`
NETWORK=`ipcalc -n $ip|awk -F= '{print $2}'`
BROADCAST=`ipcalc -b $ip|awk -F= '{print $2}'`
ip1=`echo $ip | awk -F'[./]' '{print $1}'`
ip2=`echo $ip | awk -F'[./]' '{print $2}'`
ip3=`echo $ip | awk -F'[./]' '{print $3}'`
ip4=`echo $ip | awk -F'[./]' '{print $4}'`
mask=`echo $ip | awk -F'[./]' '{print $5}'`
ipX=`echo $ip | awk -F'.' '{print $4}'`
    case "${ipX}" in
        0/24)
        IVIP1="$ip1.$ip2.$ip3.240"
        IVIP2="$ip1.$ip2.$ip3.250"
        WVIP1="$ip1.$ip2.$ip3.241"
        WVIP2="$ip1.$ip2.$ip3.251"
        WVIP3="$ip1.$ip2.$ip3.242"
        WVIP4="$ip1.$ip2.$ip3.252"
        WVIP5="$ip1.$ip2.$ip3.243"
		WVIP6="$ip1.$ip2.$ip3.253"
		GATEWAY="$ip1.$ip2.$ip3.247"
		;;
        128/25)
        IVIP1="$ip1.$ip2.$ip3.240"
        IVIP2="$ip1.$ip2.$ip3.250"
        WVIP1="$ip1.$ip2.$ip3.241"
        WVIP2="$ip1.$ip2.$ip3.251"
        WVIP3="$ip1.$ip2.$ip3.242"
        WVIP4="$ip1.$ip2.$ip3.252"
		WVIP5="$ip1.$ip2.$ip3.243"
		WVIP6="$ip1.$ip2.$ip3.253"
        GATEWAY="$ip1.$ip2.$ip3.247"
        ;;
        0/25)
        IVIP1="$ip1.$ip2.$ip3.110"
        IVIP2="$ip1.$ip2.$ip3.120"
        WVIP1="$ip1.$ip2.$ip3.111"
        WVIP2="$ip1.$ip2.$ip3.121"
        WVIP3="$ip1.$ip2.$ip3.112"
        WVIP4="$ip1.$ip2.$ip3.122"
		WVIP5="$ip1.$ip2.$ip3.113"
	 	WVIP6="$ip1.$ip2.$ip3.123"
        GATEWAY="$ip1.$ip2.$ip3.126"
        ;;
        0/26)
        IVIP1="$ip1.$ip2.$ip3.40"
        IVIP2="$ip1.$ip2.$ip3.50"
        WVIP1="$ip1.$ip2.$ip3.41"
        WVIP2="$ip1.$ip2.$ip3.51"
        WVIP3="$ip1.$ip2.$ip3.42"
        WVIP4="$ip1.$ip2.$ip3.52"
		WVIP5="$ip1.$ip2.$ip3.43"
		WVIP6="$ip1.$ip2.$ip3.53"
        GATEWAY="$ip1.$ip2.$ip3.62"
        ;;
        64/26)
        IVIP1="$ip1.$ip2.$ip3.110"
        IVIP2="$ip1.$ip2.$ip3.120"
        WVIP1="$ip1.$ip2.$ip3.111"
        WVIP2="$ip1.$ip2.$ip3.121"
        WVIP3="$ip1.$ip2.$ip3.112"
        WVIP4="$ip1.$ip2.$ip3.122"
		WVIP5="$ip1.$ip2.$ip3.113"
		WVIP6="$ip1.$ip2.$ip3.123"
        GATEWAY="$ip1.$ip2.$ip3.126"
        ;;
        128/26)
        IVIP1="$ip1.$ip2.$ip3.140"
        IVIP2="$ip1.$ip2.$ip3.150"
        WVIP1="$ip1.$ip2.$ip3.141"
        WVIP2="$ip1.$ip2.$ip3.151"
        WVIP3="$ip1.$ip2.$ip3.142"
        WVIP4="$ip1.$ip2.$ip3.152"
		WVIP5="$ip1.$ip2.$ip3.143"
		WVIP6="$ip1.$ip2.$ip3.153"
        GATEWAY="$ip1.$ip2.$ip3.190"
        ;;
        192/26)
        IVIP1="$ip1.$ip2.$ip3.240"
        IVIP2="$ip1.$ip2.$ip3.250"
        WVIP1="$ip1.$ip2.$ip3.241"
        WVIP2="$ip1.$ip2.$ip3.251"
        WVIP3="$ip1.$ip2.$ip3.242"
        WVIP4="$ip1.$ip2.$ip3.252"
		WVIP5="$ip1.$ip2.$ip3.243"
		WVIP6="$ip1.$ip2.$ip3.253"
        GATEWAY="$ip1.$ip2.$ip3.247"
        ;;
		0/27)
		IVIP1="$ip1.$ip2.$ip3.20"
		IVIP2="$ip1.$ip2.$ip3.30"
		GATEWAY="$ip1.$ip2.$ip3.1"
		;;
		64/27)
		IVIP1="$ip1.$ip2.$ip3.80"
		IVIP2="$ip1.$ip2.$ip3.90"
		GATEWAY="$ip1.$ip2.$ip3.65"
		;;
		128/27)
		IVIP1="$ip1.$ip2.$ip3.145"
		IVIP2="$ip1.$ip2.$ip3.155"
		GATEWAY="$ip1.$ip2.$ip3.129"
		;;
		160/27)
		IVIP1="$ip1.$ip2.$ip3.180"
		IVIP2="$ip1.$ip2.$ip3.190"
		GATEWAY="$ip1.$ip2.$ip3.161"
		;;
		224/27)
		IVIP1="$ip1.$ip2.$ip3.240"
		IVIP2="$ip1.$ip2.$ip3.250"
		GATEWAY="$ip1.$ip2.$ip3.225"
		;;
        *)
        IVIP1="$ip1.$ip2.$ip3.240"
        IVIP2="$ip1.$ip2.$ip3.250"
        WVIP1="$ip1.$ip2.$ip3.241"
        WVIP2="$ip1.$ip2.$ip3.251"
        WVIP3="$ip1.$ip2.$ip3.242"
        WVIP4="$ip1.$ip2.$ip3.252"
		WVIP5="$ip1.$ip2.$ip3.243"
		WVIP6="$ip1.$ip2.$ip3.253"
		GATEWAY="$ip1.$ip2.$ip3.247"
        ;;
    esac
}
function create_dhcp(){
RangeIP=`echo $KS|cut -d "." -f 1-3`
cat <<- EOF >$1
ddns-update-style interim;
allow booting;
allow bootp;

ping-check true;
ping-timeout 3;
next-server $KS;
filename "/pxelinux.0";
default-lease-time 300;
max-lease-time 1800;

class "NGIS"{
    match if(
        (substring (option vendor-class-identifier,0,9) = "PXEClient") or
        (substring ( option vendor-class-identifier,0,8) = "anaconda") or
        (substring (option vendor-class-identifier,0,4) = "RHEL") or
        (substring (option vendor-class-identifier,0,7) = "windows"));
}

subnet $RangeIP.0 netmask 255.255.255.0 {
pool{
#allow members of "NGIS";
range $RangeIP.200 $RangeIP.240;
}       
option broadcast-address $RangeIP.255;
}
EOF
}
node="nfs/node"
if [ -e nfs/node ];then
source nfs/node
fi
init
:>$node
echo "正在生成配置文件..."
if [ -e tftpboot/pxelinux.cfg/default.base ];then
cp -rf tftpboot/pxelinux.cfg/default.base tftpboot/pxelinux.cfg/default
sed -i -e "s/@KS@/$KS/g" tftpboot/pxelinux.cfg/default

	if [ -e ks/base.ks.base ];then
		cp -rf ks/base.ks.base ks/base.ks
		sed -i -e "s/@KS@/$KS/g" ks/base.ks
	else
		echo "base.ks.base error"
	fi

cal_ip $IPPOOL
echo "IPPOOL="$IPPOOL >>$node
echo "NETMASK="$NETMASK >>$node
echo "GATEWAY="$GATEWAY >>$node
echo "IVIP1="$IVIP1 >>$node
echo "IVIP2="$IVIP2 >>$node
echo "WVIP1="$WVIP1 >>$node
echo "WVIP2="$WVIP2 >>$node
echo "WVIP3="$WVIP3 >>$node
echo "WVIP4="$WVIP4 >>$node
echo "WVIP5="$WVIP5 >>$node
echo "WVIP6="$WVIP6 >>$node

else
    echo "Warning: no default found!"
    exit 1
fi
echo "KS=$KS" >>$node
echo "ETH0=eth0" >>$node
cat $node

##DHCP INIT###
if [ -e /etc/dhcpd.conf ];then
    cp /etc/dhcpd.conf /etc/dhcpd.conf.$(date +%Y%m%d-%H%M)
    create_dhcp /etc/dhcpd.conf
elif [ -e /etc/dhcp/dhcpd.conf ];then
    cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$(date +%Y%m%d-%H%M)
    create_dhcp /etc/dhcp/dhcpd.conf
else 
    echo "Warning: no dhcpd.conf found!"
    rpm -ivh software/dhcp-common-4.1.1-25.P1.el6.x86_64.rpm
	rpm -ivh software/dhcp-4.1.1-25.P1.el6.x86_64.rpm
	create_dhcp /etc/dhcp/dhcpd.conf
fi
echo "DHCP CONFIG ok!"
if grep ksis /etc/httpd/conf/httpd.conf;then
	:
else
##HTTP INIT###
#yum install -y httpd
rpm -ivh  software/apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm
rpm -ivh  software/httpd-tools-2.2.15-15.el6.x86_64.rpm
rpm -ivh  software/httpd-2.2.15-15.el6.x86_64.rpm
cat >> /etc/httpd/conf/httpd.conf <<EOF
Alias /ksis/ "/home/ksis/"
<Directory "/home/ksis/">
Options Indexes FollowSymLinks
AllowOverride None
Order allow,deny
Allow from all
</Directory>
EOF
fi
sed -i "/^Listen/d" /etc/httpd/conf/httpd.conf
sed -i "/#Listen/a  \Listen 9999" /etc/httpd/conf/httpd.conf
service httpd restart
##TFTP INIT##
rpm -ivh software/xinetd*
rpm -ivh software/tftp-server*
##NFS INIT###
mkdir nfs
cp  $PWD/nfs/config/resolv.conf $PWD/nfs
sed -i -e "s/@DNS@/$DNS/g" $PWD/nfs/resolv.conf
sed -i -e "s/@DNS1@/$DNS1/g" $PWD/nfs/resolv.conf
cp  $PWD/nfs/config/hosts $PWD/nfs
cat $PWD/nfs/sn2hosts|awk '{print $3,$2,$2}' |sed 's/\.[a-z,0-9]*$//g' >>$PWD/nfs/hosts
echo "/home/ksis   *(rw,sync,no_root_squash)" > /etc/exports

cat > /etc/xinetd.d/tftp <<EOF
# default: off
# description: The tftp server serves files using the trivial file transfer \
#	protocol.  The tftp protocol is often used to boot diskless \
#	workstations, download configuration files to network-aware printers, \
#	and to start the installation process for some operating systems.
service tftp
{
	socket_type		= dgram
	protocol		= udp
	wait			= yes
	user			= root
	server			= /usr/sbin/in.tftpd
	server_args     = -s /home/ksis/tftpboot
	disable			= no
	per_source		= 11
	cps			= 100 2
	flags			= IPv4
}
EOF


service dhcpd restart
service xinetd restart
service rpcbind restart
service nfs restart
echo "ALL done!"
