#!/bin/bash

STATE="$1"

 if [ -z "$STATE" ]
 then
	read  -p "Enter 'local' or 'remote': " STATE
fi
local_ip=""

for i in {0..4}
do
 	if [ -z "$local_ip" ]
 	then
		local_ip=`ipconfig getifaddr en$i` #or en1, maybe
	fi
done



IFS='
'
for x in `networksetup -listallnetworkservices`; 
do 
echo $x
	if [ $x == "Wi-Fi" ] ||  [ $x == "Broadcom NetXtreme Gigabit Ethernet Controller" ] ||  [ $x == "Ethernet" ]
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