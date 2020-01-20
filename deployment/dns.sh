#!/bin/bash

STATE="$1"

 if [ -z "$STATE" ]
 then
	read  -p "Enter 'local' or 'remote': " STATE
fi

local_ip=`ipconfig getifaddr en0` #or en1, maybe


IFS='
'
for x in `networksetup -listallnetworkservices $1`; 
do 
echo $x
	if [ $x == "Wi-Fi" ] ||  [ $x == "Broadcom NetXtreme Gigabit Ethernet Controller" ]
	then
		if [ $STATE == "remote" ]
		then
			networksetup -setdnsservers $x 1.1.1.1 192.168.0.1
		else
			networksetup -setdnsservers $x $local_ip

		fi
	fi
done

echo "DNS has been changed"
# sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
#sudo brew services restart dnsmasq