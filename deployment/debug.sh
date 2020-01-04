#!/bin/bash

STATE="$1"
VERSION="$2"

 if [ -z "$STATE" ]
 then
	read  -p "Enter 'start' or 'stop': " STATE
	echo $STATE
fi


if [ -z "$VERSION" ]
then
	# read  -p "PHP Version: " VERSION
	ini_info=`php -i | grep "Loaded Configuration File"`
	match="Loaded Configuration File => "
	replace=""
	php_ini=${ini_info/$match/$replace}
else
	php_ini="/usr/local/etc/php/$VERSION/php.ini"
fi

	 echo $VERSION


#do this regardless
sed -i'' -e "s/zend_extension=\"xdebug.so\"//g" $php_ini

if [ $STATE == "stop" ]
then
	echo "stopped"
else
	echo "zend_extension=\"xdebug.so\"" >> $php_ini
	echo "started"
fi


if [ -z "$VERSION" ]
then
	 brew services restart php
else
	 brew services restart php@$VERSION
fi

	# sudo brew services restart nginx


echo "Debugging has been changed"