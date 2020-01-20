#!/bin/bash

split_on_commas() {
  local IFS=,
  local WORD_LIST=($1)
  for word in "${WORD_LIST[@]}"; do
    echo "$word"
  done
}

SITENAME="$1"
CUSTOMDOMAINS="$2"

# update to make sure we have the most recent conf files
cd ~/src/dev-conf
git pull

if [ -z "$SITENAME" ]
then
	 read  -p "WP Engine Website Name: " SITENAME
	 echo $SITENAME
fi

if [ -z "$CUSTOMDOMAINS" ]
then
	 read  -p "*Optional* Enter comma separated list of custom domains: " CUSTOMDOMAINS
	 echo $CUSTOMDOMAINS
fi

# checkout website files
 git clone git@git.wpengine.com:production/$SITENAME.git $HOME/src/$SITENAME.wpengine
 cd $HOME/src/$SITENAME.wpengine
 git fetch
 git checkout master

 if test -d $HOME/src/$SITENAME.wpengine/wp-content/; 
 then 
 	git pull
 else
 # If no one has initialized this repo we have to download all the files, create the branch and set the upstream and add the gitignore
 	echo "not exist"
 	git checkout -b master
 	scp -r -o StrictHostKeyChecking=no $SITENAME:/sites/$SITENAME $HOME/src/$SITENAME.wpengine
 	mv $HOME/src/$SITENAME.wpengine/$SITENAME/* $HOME/src/$SITENAME.wpengine/
 	rm -r $HOME/src/$SITENAME.wpengine/$SITENAME
 	cp $HOME/src/dev-conf/deployment/default_files/.gitignore .gitignore
	cp -r $HOME/src/dev-conf/deployment/default_files/.vscode .vscode
 	cp $HOME/src/dev-conf/deployment/default_files/gulp.js .gulp.js

 	git add -A
 	git commit -m "initial commit"
 	git push -u origin master
 fi 

#if wp-content doens't exist then the git pull failed
 if test -d $HOME/src/$SITENAME.wpengine/wp-content/; 
 then 
 	echo "git pull worked"
 else
 	echo "git pull didn't work"
 	exit 1
 fi 

 git remote add github git@github.com:interactivesupply/$SITENAME.git

 #setup node modules and gulp install
 npm install

 # add SSH shortcut
 echo "HOST $SITENAME
 	HostName $SITENAME.ssh.wpengine.net
 	User $SITENAME
 	IdentityFile /Users/interactivesupply/.ssh/id_rsa" >> ~/.ssh/config

#download ignored files, change DB connection string to remote connection so we can grab the password.  then set the connectionstring to localhost
 scp -r -o StrictHostKeyChecking=no $SITENAME:/sites/$SITENAME/.htaccess $HOME/src/$SITENAME.wpengine/.htaccess
 wp_config="$HOME/src/$SITENAME.wpengine/wp-config.php"
 scp -r -o StrictHostKeyChecking=no $SITENAME:/sites/$SITENAME/wp-config.php $wp_config
 sed -i'' -e "s/127.0.0.1/$SITENAME.sftp.wpengine.com/g" $wp_config
 DB_PASS=`php -d log_errors=Off -r "include '$wp_config';  echo DB_PASSWORD;"`
 echo $DB_PASS;
 sed -i'' -e "s/$SITENAME.sftp.wpengine.com/localhost/g" $wp_config
 rm $wp_config-e

#download database backup from wp engine website. 
scp -r -o StrictHostKeyChecking=no $SITENAME:/sites/$SITENAME/wp-content/mysql.sql $HOME/src/tmp/$SITENAME.sql

#Create empty DB locally, if it doesn't exist
found_local_db=`mysql -u root -pc0Smo85Log1ca! -Bse "SHOW DATABASES LIKE 'wp_$SITENAME';"`
if [ "$found_local_db" == "wp_$SITENAME" ]
then
	echo "found local db";
else
	mysql -u root -pc0Smo85Log1ca! -Bse "
	create database wp_$SITENAME; 
	CREATE USER '$SITENAME'@'%' IDENTIFIED BY '$DB_PASS';
	GRANT ALL PRIVILEGES ON wp_$SITENAME.* TO '$SITENAME'@'%';
	flush privileges;"

	# Restore Local DB
	mysql -u root -pc0Smo85Log1ca! wp_$SITENAME < $HOME/src/tmp/$SITENAME.sql
fi


# restore central dev db if it doesn't exist
found_central_db=`mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! -Bse "SHOW DATABASES LIKE 'wp_$SITENAME';"`
if [ "$found_central_db" == "wp_$SITENAME" ]
then
	echo "found central db";
else
	# Create empty DB centrall
	mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! -Bse "
	create database wp_$SITENAME;
	CREATE USER '$SITENAME'@'%' IDENTIFIED BY '$DB_PASS';
	GRANT ALL PRIVILEGES ON wp_$SITENAME.* TO '$SITENAME'@'%';
	flush privileges;"

	# Restore central dev DB
	mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! wp_$SITENAME < $HOME/src/tmp/$SITENAME.sql
fi


# Add SSH info to Filezilla for sFTP
sed -i'' -e "s/<\/Servers>/<Server> <Host>${SITENAME}.ssh.wpengine.net<\/Host> <Port>22<\/Port> <Protocol>1<\/Protocol> <Type>0<\/Type> <User>${SITENAME}<\/User> <Keyfile>\/Users\/interactivesupply\/.ssh\/id_rsa<\/Keyfile> <Logontype>5<\/Logontype> <TimezoneOffset>0<\/TimezoneOffset> <PasvMode>MODE_DEFAULT<\/PasvMode> <MaximumMultipleConnections>0<\/MaximumMultipleConnections> <EncodingType>Auto<\/EncodingType> <BypassProxy>0<\/BypassProxy> <Name>${SITENAME}.wpengine.com ssh<\/Name> <Comments \/> <Colour>0<\/Colour> <LocalDir>\/Users\/interactivesupply\/src\/${SITENAME}.wpengine<\/LocalDir> <RemoteDir>1 0 5 sites ${#SITENAME} ${SITENAME}<\/RemoteDir> <SyncBrowsing>1<\/SyncBrowsing> <DirectoryComparison>1<\/DirectoryComparison> <\/Server> <\/Servers>/g" $HOME/.config/filezilla/sitemanager.xml


# create nginx block
 new_nginx_block="$HOME/src/dev-conf/sites-enabled/$SITENAME.wpengine.conf"
 if [ ! -f "$new_nginx_block" ]
 then
 	cd $HOME/src/dev-conf

 	cp $HOME/src/dev-conf/sites-enabled/example.wpengine.conf $new_nginx_block
 	sed -i'' -e "s/example/$SITENAME/g" $new_nginx_block
 	rm $new_nginx_block-e

 	split_on_commas $CUSTOMDOMAINS | while read domain; do
	   	new_nginx_block="$HOME/src/dev-conf/sites-enabled/$domain.conf"
	 	if [ ! -f "$new_nginx_block" ]
		then
			cp $HOME/src/dev-conf/sites-enabled/example.wpengine.conf $new_nginx_block
			sed -i'' -e "s/example.wpengine.com/$domain/g" $new_nginx_block
		 	sed -i'' -e "s/example/$SITENAME/g" $new_nginx_block
			rm $new_nginx_block-e
	   	fi
	done

 	git add -A
 	git commit -m "Adding webserver conf for $SITENAME"
 	git push
 fi

# add domain to SSL settings and regenerate, git add commit and push
cd $HOME/src/dev-conf/deployment
./add_ssl_domain.sh "$SITENAME.wpengine.com,$CUSTOMDOMAINS"

# add sql workbench connection
# ...
# $HOME/Library/Application Support/MySQL/Workbench/connections.xml


# add DNS entry for $SITENAME.wpengine.com
cd $HOME/src/dev-conf/deployment
./point_domain_locally.sh "$SITENAME.wpengine.com,$CUSTOMDOMAINS"

 # create database reset scripts
 reset_local_db="$HOME/src/$SITENAME.wpengine/reset_local_db.sh"
 if [ ! -f "$reset_local_db" ]
 then
 	touch $reset_local_db
 	chmod +x $reset_local_db
 	echo "cd $HOME/src/dev-conf/deployment" >> $reset_local_db
 	echo "./reset_db.sh wp_$SITENAME 127.0.0.1 $SITENAME /sites/$SITENAME/wp-content/mysql.sql" >> $reset_local_db
 fi

 reset_central_db="$HOME/src/$SITENAME.wpengine/reset_central_db.sh"
 if [ ! -f "$reset_central_db" ]
 then
 	touch $reset_central_db
 	chmod +x $reset_central_db
 	echo "cd $HOME/src/dev-conf/deployment" >> $reset_central_db
 	echo "./reset_db.sh wp_$SITENAME 192.168.0.14 $SITENAME /sites/$SITENAME/wp-content/mysql.sql" >> $reset_central_db
 fi

 # add VS code solution files
 vscode_project="$HOME/src/$SITENAME.wpengine/$SITENAME.code-workspace"
 if [ ! -f "$vscode_project" ]
 then
 	cp $HOME/src/dev-conf/deployment/default_files/example.code-workspace $vscode_project
 	sed -i'' -e "s/example/$SITENAME/g" $vscode_project
 	rm $vscode_project-e
 fi

 open $vscode_project

 # restart nginx
 sudo brew services restart nginx

# open newly added website in Chrome
open -na "Google Chrome" --args --new-window "https://$SITENAME.wpengine.com"

 # todo: add these reset scripts to the git ignore
 #create debug start and stop script inside of website... and add to gitignore
 # initialize brand new git repo from WPE
 # will the .gitignore needed to be committed (and can it be without conflicts with other repos)
 # any node_js or bower stuff to do?