#!/bin/bash

STATE="$1"
VERSION="$2"

 if [ -z "$STATE" ]
 then
	read  -p "Enter 'start' or 'stop': " STATE
fi

 if [ -z "$VERSION" ]
 then
	read  -p "PHP Version (Optional): " VERSION
fi


if [ -z "$VERSION" ]
then
	VERSION="7.4"
fi

php_ini="/Users/interactivesupply/src/dev-conf/php/php_$VERSION.ini"
#do this regardless
sed -i'' -e "s/zend_extension=\"xdebug.so\"//g" $php_ini

if [ $STATE == "stop" ]
then
	echo "stopped"
else
	echo "zend_extension=\"xdebug.so\"" >> $php_ini
	echo "started"
fi

sudo brew services restart php@$VERSION

echo "PHP $VERSION: Debugging has been changed"