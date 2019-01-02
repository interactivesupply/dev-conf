#!/bin/bash
echo "Dropping DB"
mysql -u root -pc0Smo85Log1ca! -e "DROP DATABASE luther;"
echo "Create DB"
mysql -u root -pc0Smo85Log1ca! -e "CREATE DATABASE luther;"
echo "Grant User Permissions"
mysql -u root -pc0Smo85Log1ca! -e "GRANT ALL PRIVILEGES ON luther.* TO 'luther_user'@'%';"
echo "Flush Privileges"
mysql -u root -pc0Smo85Log1ca! -e "flush privileges;"
echo "Copying db backup file"
cp "/volume1/Backup/tgc_s3_db/luther-$(date +\%F).sql" /volume1/Backup/tmp
echo "Replace strings"
sed -i 's/utf8mb4/utf8/g' "/volume1/Backup/tmp/luther-$(date +\%F).sql"
sed -i 's/utf8_unicode_520_ci/utf8_general_ci/g' "/volume1/Backup/tmp/luther-$(date +\%F).sql"
echo "Restore DB"
sudo mysql -u root -pc0Smo85Log1ca! luther < /volume1/Backup/tmp/luther-$(date +\%F).sql
echo "Removing File"
rm "/volume1/Backup/tmp/luther-$(date +\%F).sql"
