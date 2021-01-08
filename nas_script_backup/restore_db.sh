#!/bin/bash
cd /volume1/web/S3/db_bak/prod
ZIPFILES=*.zip
for zipFileName in  $ZIPFILES; do
	echo "Working with $zipFileName"
	dbName="$(cut -d'-' -f1 <<<"$zipFileName")"
	echo "DB: $dbName"
	echo "Extracting contents of zip"
	rm -r ${dbName}_extracted
	7z x `ls *$dbName* | sort -n | head -1` -o${dbName}_extracted
	SQLFILES=${dbName}_extracted/wp_*.sql
	for sqlFile in  $SQLFILES; do
		echo "Replacing strings in $sqlFile"
		sed -i 's/utf8mb4/utf8/g' $sqlFile
		sed -i 's/utf8_unicode_520_ci/utf8_general_ci/g' $sqlFile
		echo "Executing $sqlFile"
		 mysql -u root -pc0Smo85Log1ca! $dbName < $sqlFile
	done
done
echo "Deleting folder"
rm -r ${dbName}_extracted
echo "All done."