AN=`lspci | grep -i net|wc -l`
ANN=$[AN-1]
i=0
TE=0
while [ $i -le $ANN ]
do
        if ifconfig eth$i >/dev/null;then
                if ethtool -i eth$i|grep ixg || ethtool -i  eth$i|grep be2net;then
                        TE=$[TE+1]
                fi
        fi
        i=$[$i+1]
done
GE=$[AN-TE]
GEN=$[GE-1]
if echo "$ALOS"|grep 'rh6[0-9]'&&[ "X$MACBOND" == "XYES" ];then
        :>/etc/udev/rules.d/70-persistent-net.rules 
        if ethtool -i  eth0|grep ixg || ethtool -i  eth0|grep be2net;then
        for i in 0 1 2 3 4 5 6 7 
        do
                if ifconfig eth$i >/dev/null;then
                        udev_name="eth$i"
                        udev_mac=`ifconfig eth$i|grep "eth$i"|awk '{print $5}'|tr A-Z a-z`
                        [ "X$udev_mac" != "X" ]&&echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$udev_mac\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"$udev_name\"" >>/etc/udev/rules.d/70-persistent-net.rules
                fi
        done
        else
        i=0
        while [ $i -le $GEN ]
        do
                n=`expr $i + $TE`
                udev_name="eth"$n
                echo $udev_name
                udev_mac=`ifconfig eth$i|grep "eth$i"|awk '{print $5}'|tr A-Z a-z`   
         [ "X$udev_mac" != "X" ]&&echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$udev_mac\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"$udev_name\"" >>/etc/udev/rules.d/70-persistent-net.rules
                i=$[$i+1]
        done

        i=$GE
        while [ $i -le $ANN ]
        do
                n=`expr $i - $GE`
                udev_name="eth"$n
                echo $udev_name
                udev_mac=`ifconfig eth$i|grep "eth$i"|awk '{print $5}'|tr A-Z a-z`   
        [ "X$udev_mac" != "X" ]&&echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$udev_mac\", ATTR{type}==\"1\", KERNEL==\"eth*\", NAME=\"$udev_name\"" >>/etc/udev/rules.d/70-persistent-net.rules

                i=$[$i+1]
        done
        fi

fi
