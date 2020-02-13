openssl req -out /Users/interactivesupply/src/dev-conf/ssl/server.csr -newkey rsa:2048 -nodes -keyout /Users/interactivesupply/src/dev-conf/ssl/server.key -config /Users/interactivesupply/src/dev-conf/ssl/generation_settings/server.csr.cnf
openssl x509 -req -in /Users/interactivesupply/src/dev-conf/ssl/server.csr -CA /Users/interactivesupply/src/dev-conf/ssl/rootCA.pem -CAkey /Users/interactivesupply/src/dev-conf/ssl/rootCA.key -CAcreateserial -out /Users/interactivesupply/src/dev-conf/ssl/server.crt -days 500 -sha256 -extfile /Users/interactivesupply/src/dev-conf/ssl/generation_settings/v3.ext 
openssl pkcs12 -export -inkey /Users/interactivesupply/src/dev-conf/ssl/server.key  -in /Users/interactivesupply/src/dev-conf/ssl/server.crt -out /Users/interactivesupply/src/dev-conf/ssl/server.pfx

sudo openssl dhparam -out /Users/interactivesupply/src/dev-conf/ssl/dhparam.pem 128
