#!/bin/bash
DB_NAME="$1"
DB_HOST="$2"
SSH_HOST="$3"   
REMOTE_DB_FILE_URI="$4"
PORT=$5

if [ -z "$PORT" ]
then
	 PORT=22
fi

scp -P $PORT -r -o StrictHostKeyChecking=no $SSH_HOST:$REMOTE_DB_FILE_URI ~/src/tmp/$DB_NAME.sql
mysql -h $DB_HOST -u root -pc0Smo85Log1ca! $DB_NAME < ~/src/tmp/$DB_NAME.sql
echo "restore is complete"