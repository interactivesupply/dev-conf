#!/bin/bash

split_on_commas() {
  local IFS=,
  local WORD_LIST=($1)
  for word in "${WORD_LIST[@]}"; do
    echo "$word"
  done
}

CUSTOMDOMAINS="$1"

if [ -z "$CUSTOMDOMAINS" ]
then
	 read  -p "Enter comma separated list of domains to point locally: " CUSTOMDOMAINS
	 echo $CUSTOMDOMAINS
fi

# add DNS entry for $SITENAME.wpengine.com
local_ip=`ipconfig getifaddr en0` #or en1, maybe
split_on_commas $CUSTOMDOMAINS | while read domain; do

	if [ -z "$match" ] && [[ ! -z "$domain" ]]
	then
		echo "address=/.$domain/$local_ip" >> /usr/local/etc/dnsmasq.d/development.conf
	fi
done

#don't think this is necessary right now
 sudo brew services restart dnsmasq
 #sudo dscacheutil -flushcache
 sudo killall -HUP mDNSResponder
echo "domain(s) pointed locally"