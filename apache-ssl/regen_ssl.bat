openssl x509 -req -in C:\src\dev-conf\apache-ssl\server.csr -CA C:\src\dev-conf\apache-ssl\rootCA.pem -CAkey C:\src\dev-conf\apache-ssl\rootCA.key -CAcreateserial -out C:\src\dev-conf\apache-ssl\server.crt -days 500 -sha256 -extfile C:\src\dev-conf\apache-ssl\generation_settings\v3.ext