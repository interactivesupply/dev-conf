openssl genrsa -des3 -out C:\src\dev-conf\apache-ssl\rootCA.key 2048
openssl req -x509 -new -nodes -key C:\src\dev-conf\apache-ssl\rootCA.key -days 2048 -out C:\src\dev-conf\apache-ssl\rootCA.pem -config C:\src\dev-conf\apache-ssl\generation_settings\rootCA.csr.cnf
openssl pkcs12 -export -inkey C:\src\dev-conf\apache-ssl\rootCA.key  -in C:\src\dev-conf\apache-ssl\rootCA.pem -out C:\src\dev-conf\apache-ssl\rootCA.pfx
