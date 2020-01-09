#!/bin/bash

split_on_commas() {
  local IFS=,
  local WORD_LIST=($1)
  for word in "${WORD_LIST[@]}"; do
    echo "$word"
  done
}

DOMAINS="$1"
SSL_DOMAIN_FILE="$HOME/src/dev-conf/ssl/dev.interactivesupply.com.ext"

if [ -z "$DOMAINS" ]
then
	 read  -p "Enter comma separated list of domains: " DOMAINS
	 echo $DOMAINS
fi


LAST_SSL=`tail -1 $HOME/src/dev-conf/ssl/dev.interactivesupply.com.ext`
LAST_SSL="$(echo $LAST_SSL | cut -d'.' -f2)"
LAST_SSL="$(echo $LAST_SSL | cut -d' ' -f1)"

split_on_commas $DOMAINS | while read domain; do
	match=`grep $domain $SSL_DOMAIN_FILE`

	if [ -z "$match" ] && [[ ! -z "$domain" ]]
	then
		LAST_SSL=$((LAST_SSL+1))
		 echo $"DNS.$LAST_SSL = $domain"  >> $SSL_DOMAIN_FILE
	fi
done



openssl x509 -req -in $HOME/src/dev-conf/ssl/dev.interactivesupply.com.csr -CA $HOME/src/dev-conf/ssl/myCA.pem -CAkey $HOME/src/dev-conf/ssl/myCA.key -CAcreateserial -out $HOME/src/dev-conf/ssl/dev.interactivesupply.com.crt -days 824 -sha256 -extfile $SSL_DOMAIN_FILE

cd $HOME/src/dev-conf
git add -A
git commit -m "Generating SSL for $DOMAINS"
git push