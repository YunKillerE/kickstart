#!/bin/bash

sed -i "s/udp6/#udp6/g" /etc/netconfig
sed -i "s/tcp6/#tcp6/g" /etc/netconfig

#sed -i '/PS1/d' /root/.bashrc
#sed -i '/PS1/d' /home/admin/.bashrc
#echo "export PS1='\n\e[1;37m[\e[1;31m\`hostname -d|tr a-z A-Z\` \e[m\e[1;32m\u\e[m\e[1;33m@\e[m\e[1;35m\h\e[m \e[4m\`pwd\`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\\$'" >> /root/.bashrc
#echo "export PS1='\n\e[1;37m[\e[1;31m\`hostname -d|tr a-z A-Z\` \e[m\e[1;32m\u\e[m\e[1;33m@\e[m\e[1;35m\h\e[m \e[4m\`pwd\`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\\$'" >> /home/admin/.bashrc



cat >/etc/rc.local <<-EOF
#!/bin/bash
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local
EOF
echo "last reboot......"
reboot
