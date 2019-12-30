openssl genrsa -des3 -out /Users/interactivesupply/src/dev-conf/ssl/rootCA.key 2048
openssl req -x509 -new -nodes -key /Users/interactivesupply/src/dev-conf/ssl/rootCA.key -days 2048 -out /Users/interactivesupply/src/dev-conf/ssl/rootCA.pem -config /Users/interactivesupply/src/dev-conf/ssl/generation_settings/rootCA.conf
openssl pkcs12 -export -inkey /Users/interactivesupply/src/dev-conf/ssl/rootCA.key  -in /Users/interactivesupply/src/dev-conf/ssl/rootCA.pem -out /Users/interactivesupply/src/dev-conf/ssl/rootCA.pfx


sudo security add-trusted-cert \
  -d -r trustRoot \
  -k /Library/Keychains/System.keychain /usr/local/etc/ssl/certs/self-signed.crt