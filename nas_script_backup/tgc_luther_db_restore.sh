#!/bin/bash
echo "Dropping DB"
mysql -u root -pc0Smo85Log1ca! -e "DROP DATABASE luther_sandbox;"
echo "Create DB"
mysql -u root -pc0Smo85Log1ca! -e "CREATE DATABASE luther_sandbox;"
echo "Grant User Permissions"
mysql -u root -pc0Smo85Log1ca! -e "GRANT ALL PRIVILEGES ON luther_sandbox.* TO 'luther_user'@'%';"
echo "Flush Privileges"
mysql -u root -pc0Smo85Log1ca! -e "flush privileges;"
echo "Copying db backup file"
cp "/volume1/Backup/tgc_s3_db/luther-$(date +\%F).sql" "/volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql"
echo "Replace strings"
sed -i 's/utf8mb4/utf8/g' "/volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql"
sed -i 's/utf8_unicode_520_ci/utf8_general_ci/g' "/volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql"
sed -i 's/www\.thegospelcoalition\.org/luther\.tgc\.localhost/g' "/volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql"
echo "Restore DB"
sudo mysql -u root -pc0Smo85Log1ca! luther_sandbox < /volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql
echo "Removing File"
rm "/volume1/Backup/tmp/luther_sandbox-$(date +\%F).sql"