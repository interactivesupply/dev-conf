openssl req -out C:\src\dev-conf\apache-ssl\server.csr -newkey rsa:2048 -nodes -keyout C:\src\dev-conf\apache-ssl\server.key -config C:\src\dev-conf\apache-ssl\generation_settings\server.csr.cnf
openssl x509 -req -in C:\src\dev-conf\apache-ssl\server.csr -CA C:\src\dev-conf\apache-ssl\rootCA.pem -CAkey C:\src\dev-conf\apache-ssl\rootCA.key -CAcreateserial -out C:\src\dev-conf\apache-ssl\server.crt -days 500 -sha256 -extfile C:\src\dev-conf\apache-ssl\generation_settings\v3.ext 
openssl pkcs12 -export -inkey C:\src\dev-conf\apache-ssl\server.key  -in C:\src\dev-conf\apache-ssl\server.crt -out C:\src\dev-conf\apache-ssl\server.pfx

