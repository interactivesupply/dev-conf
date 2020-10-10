#!/bin/bash
WP_ENGINE_WEBSITE="$1"   
DB_ROOT_PASS=""
TIMESTAMP=$(date +%F)
CONFIRMATION=""

if [ -z "$WP_ENGINE_WEBSITE" ]
then
	 read  -p "WP Engine Website Name (Prefix): " WP_ENGINE_WEBSITE
	 echo $WP_ENGINE_WEBSITE
fi
 
if [ -z "$DB_ROOT_PASS" ]
then
	 read  -p "Local Database Root Pass: " DB_ROOT_PASS
	 echo $DB_ROOT_PASS
fi
 
if [ -z "$CONFIRMATION" ]
then
	 read  -p "Type 'KILL PRODUCTION' because you're overwriting a PRODUCTION DATABASE: " CONFIRMATION
fi

if [ "$CONFIRMATION" == "KILL PRODUCTION" ]
then
  

echo "starting restore"

sudo  "/Applications/MySQLWorkbench 8.0.app/Contents/MacOS/mysqldump"  --user=root --password=$DB_ROOT_PASS --host=localhost --protocol=tcp --port=3306 --default-character-set=utf8 --skip-triggers "wp_$WP_ENGINE_WEBSITE" > "$HOME/src/tmp/wp_${WP_ENGINE_WEBSITE}_${TIMESTAMP}.sql"
scp -r -o StrictHostKeyChecking=no  "$HOME/src/tmp/wp_${WP_ENGINE_WEBSITE}_${TIMESTAMP}.sql" $WP_ENGINE_WEBSITE:"/sites/${WP_ENGINE_WEBSITE}/wp-content/local_mysql.sql"
ssh $WP_ENGINE_WEBSITE "wp db import /sites/${WP_ENGINE_WEBSITE}/wp-content/local_mysql.sql"
rm "$HOME/src/tmp/wp_${WP_ENGINE_WEBSITE}_${TIMESTAMP}.sql"
echo "remote restore is complete"
else
    echo "You're not ready to SCHMOW"
fi
