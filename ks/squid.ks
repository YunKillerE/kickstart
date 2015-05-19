# squid.ks.cfg
#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Firewall configuration
firewall --disabled
# Install OS instead of upgrade
install
# Use NFS installation media
#url --url="ftp://admin:123456@192.168.217.1/"
nfs --server=10.120.8.251 --dir=/opt/iso/6u2
# Root password
rootpw --iscrypted $6$VYpyu6gI$tCow09wOaPdaevfwM5lYr/Ex2LYY1FZVsMtm6hB991ZceiNb.R2OqA/6OqvIf.RlLQ1hdamshKl9ErqplPE6x1 
# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on
# System authorization information
auth  --useshadow  --passalgo=md5
# Use text mode install
text
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# Installation logging level
logging --level=info
# Reboot after installation
reboot
# System timezone
timezone --isUtc Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr --driveorder=sda,sdb,sdc,sdd --append="console=tty0 console=ttyS0,115200"
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part /boot --asprimary --fstype="ext3"  --size=512 --ondrive=sda
part swap --asprimary --fstype="swap"  --size=2048 --ondrive=sda
part / --asprimary --fstype="ext3"  --size=20480 --ondrive=sda
part /var --fstype="ext3"  --size=6144 --ondrive=sda
#part /cache1 --fstype="ext3" --grow --fsoptions="defaults,noatime" --size=1 --ondrive=sda

%packages
@additional-devel
@base
@core
@development
@system-admin-tools
@system-management
@system-management-snmp
OpenIPMI
ipmitool

%end

%post
cat >> /etc/rc.local <<-EOF
mkdir /mnt/temp
mount -o nolock 10.120.8.251:/opt/iso /mnt/temp
cd /mnt/temp/postinst/
./squid.sh
EOF

