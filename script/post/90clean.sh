#!/bin/sh
#****************************************************************#
# ScriptName: clean.sh
# Author: liujmsunits@hotmail.com
# Create Date: 2012-05-29 15:37
# Modify Author: $liujmsunits@hotmail.com
# Modify Date: 2015-05-05 20:50
# Function: 
#***************************************************************#
rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_key /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key.pub /etc/ssh/ssh_host_key.pub /etc/ssh/ssh_host_rsa_key.pub /var/cfengine/cfengine_lock_db /root/backup/slcn_start.sh
for i in cron anaconda.syslog kern messages secure  
do
   >/var/log/$i
done
crontab -r
:>/var/log/wtmp
>/var/log/wtmp
rm -rf /root/backup
:> /root/.bash_history
> /root/.bash_history
yum clean all
rm -f /usr/local/sbin/cronolog
rm -f /usr/local/sbin/cronosplit
rm -fr /var/lib/rpm/__db*
rpm -v --rebuilddb
echo "CLEAN_FLAG"
sed -i 's/^hiddenmenu/#hiddenmenu/' /boot/grub/grub.conf
sed -i 's/^splashimage/#splashimage/' /boot/grub/grub.conf
cat /boot/grub/grub.conf
sed -i "/timeout=120/d" /etc/yum.conf
rm -f /etc/resolv.conf.predhclient*
rpm -qa |wc -l
