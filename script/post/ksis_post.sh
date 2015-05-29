#!/bin/bash
#****************************************************************#
# ScriptName: ksis_post.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2012-05-29 13:15
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-05-30 03:31
# Function:  
#***************************************************************#
function send_mail() {
[ "$JIMMYSN" == "" ]&& JIMMYSN=`dmidecode -s system-serial-number|grep -v '^#'`
if ( /sbin/ifconfig|grep -iE -q 'inet ?addr:10.' ) ; then
    local smtpserver="127.0.0.1"

else
    local smtpserver="XO.COM"
fi
local mailfrom="KSIS_ERROR@KSIS.com"
local mailto="liujmsunits@hotmail.com"
local mailto1="liujmsunits@hotmail.com"
local SUBJECT="ksis_install.sh run wrong! please check"
local message="HN: $JIMMYSN IP: $DHCPIP ngis-install.sh fail:  $1"
nc ${smtpserver} 25 <<-EOF >/dev/null 2>&1
mail from:<${mailfrom}>
rcpt to:<${mailto}>
data
From:<${mailfrom}>
To:<${mailto}>
To:<${mailto1}>
subject:${SUBJECT}
===============================================================
${message}
===============================================================
.
quit
EOF
}

function error_log(){
echo $1 >>/root/install.log
progress  $1 7777
send_mail "$1" &
exit 1
}
function progress(){
:
}

E_file="/tmp/install_E_flag"
W_file="/root/install_warn.log"

PWD=`pwd`

source $PWD/00*.sh

#source $PWD/$JIMMYSN

for i in `ls /root/post/[01-99]*.sh`
do
	progress `basename $i` 8888
	source $i 2>&1|tee -a /root/post/ksis_post.log
	[ -e $E_file ] && E_flag=`cat $E_file|tr -d " \n"`&&error_log $E_flag
done


