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

	if [ $x == "Wi-Fi" ] ||  [ $x == "Broadcom NetXtreme Gigabit Ethernet Controller" ]
	then
		if [ $STATE == "remote" ]
		then
			networksetup -setdnsservers $x "empty"
		else
			networksetup -setdnsservers $x $local_ip

		fi
	fi
done

sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
brew services restart dnsmasq