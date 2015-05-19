#!/bin/sh
#****************************************************************#
# ScriptName: oob_os_init.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2012-08-14 11:21
# Modify Author: $SHTERM_REAL_USER@alibaba-inc.com
# Modify Date: 2015-05-05 20:48
# Function: 
#***************************************************************#
function get_PN(){
	PRONAME=`dmidecode -s system-product-name|grep -v "^#"|sed 's/ *$//g'`
	if [ "X$PRONAME" == "X" ] ;then
		echo -n "[ERROR]: get_proname() zero PRONAME"
		return 4
	elif echo "${PRONAME}" | grep -qi "IBM" ;then
		IBM_PRONAME=$(echo "${PRONAME}" | awk '{print $2" "$3}')
		echo -n "$IBM_PRONAME"
		return 0
	else
		echo -n "$PRONAME"
		return 0
	fi
}

function get_SN(){
	dmidecode -s system-serial-number|grep -v '^#'|sed 's/ //g'
	echo $SN|grep -i 'ToBeFilled'&&SN=`/usr/sbin/dmidecode | grep "Serial Number"| grep -v -i "To be filled"|head -1| awk '{print $3}'`
}

function get_MANU(){
	dmidecode -s system-manufacturer|grep -v '^#'|sed 's/ //g'
}

function get_TTYS(){
	case $Proname in
		"PowerEdge M610"|"PowerEdge 1950"|"PowerEdge 2950"|"PowerEdge 6950"|"PowerEdge R900")
		FSBR="57600"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="1"
		;;
		"PowerEdge C2100"|"C2100")
		FSBR="19200"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="1"
		;;
		"PowerEdge R620"|*R720*|DCS*|*C6220*|XS23*|FS*|"C6100"|CS24*)
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		"PowerEdge R710"|"PowerEdge R610"|"PowerEdge R510"|"PowerEdge R910")
		FSBR="115200"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="1"
		;;
		"ProLiant DL185 G5")
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="2"
		;;
		"ProLiant DL360 G5"|"ProLiant DL360 G7"|"ProLiant DL380 G7"|"ProLiant DL380 G8"|"ProLiant DL365 G5")
		FSBR="9600"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="2"
		;;
		"ProLiant DL380e Gen8")
		FSBR="115200"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="2"
		;;
		"ProLiant DL360p*")
        FSBR="115200"
        CONSOLE="ttyS1"
        IPMILANCHANNEL="2"
        ;;
		ProLiant*)
		FSBR="9600"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="2"
		;;
		*RH2285*|*BH620*|*XH320*|*xh320*)
		FSBR="9600"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		*"System x3550"*|*"System x3650"*)
		FSBR="57600"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="Not Support"
		;;
		"System x"|*7870I*)
		FSBR="115200"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="Not Support"
		;;
		*"System x3630"*)
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="Not Support"
		;;
		"AS500 N2")
		FSBR="9600"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="Not Support"
		;;
		"OceanStor T3500")
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="Not Support"
		;;
		"SA5212H2")
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		"SA5248L"|"ProLiant DL380p Gen8"*|*"K900-1G"*|*"B600_1G"*|*"I620-G10"*|*"I620-T10"*)
		FSBR="115200"
		CONSOLE="ttyS1"
		IPMILANCHANNEL="1"
		;;
		*"A40"*)
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		*"B700G2"*|*"RH2288"*|*"RH1285"*)
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		"Tecal"|"Tecal BH28")
		FSBR="null"
		CONSOLE="null"
		IPMILANCHANNEL="1"
		;;
		"To Be Filled By O.E.M.")
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
		*)
		FSBR="115200"
		CONSOLE="ttyS0"
		IPMILANCHANNEL="1"
		;;
	esac
	echo "FSBR:$FSBR"
	echo "CONSOLE:$CONSOLE"
	echo "IPMILANCHANNEL:$IPMILANCHANNEL"
	echo "LICENSE:$LICENSE"
}
function init_os_grub(){
	GRUBCFG="/boot/grub/grub.conf"
	[ ! -f "$GRUBCFG" ]&&echo "$GRUBCFG not exist">>$E_file&&exit 1

    # 普通内核特征 : kernel /vmlinuz-2.6.18-194.8.1.el5 ro root=LABEL=/ console=ttyS0,9600
    # 注意这两者的区分

    # 为了防止误操作，ttyS[0-1] 只匹配已知的端口 ttyS0 和 ttyS1 
    # 这个对防止引起误操作，起到很重要的作用
    sed -i '/^[ \t]*kernel \/vmlinu/s/[ \t]\{1,\}console=ttyS[01],[0-9]\{1,\}[ \t]*/ /' ${GRUBCFG}
    sed -i '/^[ \t]*kernel \/vmlinu/s/[ \t]\{1,\}console=tty0[ \t]*/ /'            ${GRUBCFG}

    sed -i '/^[ \t]*kernel \/vmlinu/s/[ \t]*rhgb[ \t]*quiet//'    ${GRUBCFG}
    sed -i '/^[ \t]*kernel \/vmlinu/s/\([ \t]*\)$//'              ${GRUBCFG}

    # 这里 ${CONSOLE} 与 tty0 的顺序是有讲究的。
    # 按照 /usr/src/linux/Documents/serial-console.txt 的说法：
    # You can specify multiple console= options on the kernel command line.
    # Output will appear on all of them. The last device will be used when
    # you open /dev/console.
    sed -i "/^[ \t]*kernel \/vmlinuz/s/$/ console=tty0 console=${CONSOLE},${FSBR} /"    ${GRUBCFG}

}
function set_oob(){
	ipmitool lan set $IPMILANCHANNEL access on
	if [[ "X"$OOB == "X" ]];then
	ipmitool lan set $IPMILANCHANNEL ipsrc dhcp
	else
	ipmitool lan set $IPMILANCHANNEL ipsrc static
	ipmitool lan set $IPMILANCHANNEL ipaddr $OOB
	ipmitool lan set $IPMILANCHANNEL netmask 255.255.255.0
	fi
	ipmitool user set name 3  taobao
	ipmitool user set  password 3 9ijn0okm
	ipmitool user enable 3
	ipmitool user priv 3 4 $IPMILANCHANNEL
	ipmitool sol payload enable $IPMILANCHANNEL 3
	ipmitool channel setaccess $IPMILANCHANNEL 3 callin=on ipmi=on link=on privilege=4
	id=`ipmitool user list $IPMILANCHANNEL | grep taobao | awk '{if($1 !~ 3 )print $1}'`
	for i in $id;do ipmitool user set password $i 9ijn0okm; done
	sleep 2
}
Proname=`get_PN`
SN=`get_SN`
Manu=`get_MANU`

get_TTYS
init_os_grub


echo "INIT_OOB_OS_FLAG"
cat /boot/grub/grub.conf
cat /etc/inittab
cat /etc/securetty
echo "rate=$FSBR" >>/root/cloneinfo
echo "console=$CONSOLE" >>/root/cloneinfo
if echo "$FSBR"|grep 'ERROR';then
	echo "CONSOLE_SET_ERROR" >>$E_file
fi
