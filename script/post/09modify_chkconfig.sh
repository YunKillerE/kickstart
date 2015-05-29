#!/bin/bash
#****************************************************************#
# ScriptName: modify_chkconfig.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2015-04-29 16:08
# Modify Author: $SHTERM_REAL_USER@alibaba-inc.com
# Modify Date: 2015-05-05 20:41
# Function: 
#***************************************************************#
function modify_chkconfig()
{
    echo "::Modify chkconfig for the new system..."
	for a in `chkconfig --list|grep 0:|awk '{print $1}'`
	do
		case "$a" in
			"sshd"    ) STATUS=on;;
			"crond"   ) STATUS=on;;
			"network" ) STATUS=on;;
			"rsyslog") STATUS=on;;
			"ntpd"    ) STATUS=on;;
			"ipmi"    ) STATUS=on;;
			"changeDevice"    ) STATUS=on;;
			"snmpd" ) STATUS=on;;
			*         ) STATUS=off;;
		esac
	/sbin/chkconfig --level 345 $a $STATUS
	done
	echo "::End modify chkconfig"
}
modify_chkconfig

wget -T3 -t2 -O /etc/ntp.conf http://${KS}:9999/ksis/conman/system/ntp.conf &>/dev/null
wget -T3 -t2 -O /etc/sysctl.conf http://${KS}:9999/ksis/conman/system/sysctl.conf &>/dev/null
#wget -T3 -t2 -O /etc/sudoers http://${KS}:9999/ngis/conman/system/sudoers &>/dev/null
wget -T3 -t2 -O /etc/modprobe.d/disable_ipv6.conf http://${KS}:9999/ksis/conman/system/disable_ipv6.conf &>/dev/null

echo "CHKCONFIG_FLAG"

rpm -ihv "http://${KS}:9999/ksis/software/hwconfig-1.16.8-2.noarch.rpm"

if grep root /etc/security/limits.conf
then
	:
else

echo "root    soft    nofile  65535
root    hard    nofile  65535
admin   soft    nofile  65535
admin   hard    nofile  65535" >> /etc/security/limits.conf

fi
