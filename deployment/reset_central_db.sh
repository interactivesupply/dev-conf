#!/bin/bash
SITENAME="$1"

scp $SITENAME:/sites/$SITENAME/wp-content/mysql.sql ~/src/tmp/$SITENAME.sql
mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! wp_$SITENAME < ~/src/tmp/$SITENAME.sql

