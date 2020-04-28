#!/bin/bash

STATE="$1"

 if [ -z "$STATE" ]
 then
	read  -p "Enter 'local' or 'remote': " STATE
fi
local_ip=""

for i in {0..6}
do
 	if [ -z "$local_ip" ]
 	then
		local_ip=`ipconfig getifaddr en$i` #or en1, maybe
	fi
done

#save IP to log for find and replace purposes elsewhere


IFS='
'
for x in `networksetup -listallnetworkservices`; 
do 
echo $x
	if [ $x == "Wi-Fi" ] ||  [ $x == "Broadcom NetXtreme Gigabit Ethernet Controller" ] ||  [ $x == "Ethernet"  ] ||  [ $x == "ISC VPN"  ] ||  [ $x == "USB 10/100/1000 LAN"  ]
	then
	  	#nic_ip=$(networksetup -getinfo "$x" | awk 'NR ==2' | awk '{print $3'})
    	#echo "nic_ip : $nic_ip"

		if [ $STATE == "remote" ]
		then
			networksetup -setdnsservers $x 1.1.1.1 #empty #1.1.1.1 192.168.0.1
		else
			networksetup -setdnsservers $x $local_ip

		fi
	fi
done

last_local_ip_log=~/src/tmp/last_local_ip.txt
last_local_ip=$(<$last_local_ip_log)
sed -i'' -e "s/$last_local_ip/$local_ip/g" /usr/local/etc/dnsmasq.d/development.conf

#log the new IP to this file
echo $local_ip > $last_local_ip_log

if [ "$local_ip" != "$last_local_ip" ]
then
	echo "DNS restart required"
	sudo brew services restart dnsmasq
fi

echo "DNS has been changed"
# sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
#sudo brew services restart dnsmasq