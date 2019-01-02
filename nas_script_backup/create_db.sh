#!/bin/bash
echo Enter DB name
read dbName
echo "Creating database: $dbName"
mysql -u root -pc0Smo85Log1ca! -e "CREATE DATABASE $dbName;"
echo "DB created successfully"
echo "Enter Username for DB $dbName"
read dbUserName
echo "Enter password for user $dbUserName"
read dbPassword
echo "Creating DB User"
mysql -u root -pc0Smo85Log1ca! -e "CREATE USER '$dbUserName'@'%' IDENTIFIED BY '$dbPassword';"
echo "User created successfully"
echo "Granting privileges for $dbUserName to $dbName"
mysql -u root -pc0Smo85Log1ca! -e "GRANT ALL PRIVILEGES ON $dbName.* TO '$dbUserName'@'%'; flush privileges;"
echo "Privileges granted successfully"
echo "All done."



