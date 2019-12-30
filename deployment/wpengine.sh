#!/bin/bash

SITENAME="$1"

if [ -z "$SITENAME" ]
then
	 read  -p "WP Engine Website Name: " SITENAME
	 echo $SITENAME
fi

##add SSH shortcut
# echo "HOST $SITENAME
# 	HostName $SITENAME.ssh.wpengine.net
# 	User $SITENAME
# 	IdentityFile /Users/interactivesupply/.ssh/id_rsa" >> ~/.ssh/config

##checkout website files
# git clone git@git.wpengine.com:production/$SITENAME.git $HOME/src/$SITENAME.wpengine
# cd ~/src/$SITENAME.wpengine
# git fetch
# git checkout master

# if test -d $HOME/src/$SITENAME.wpengine/wp-content/; 
# then 
# 	 echo "directory exists"; 
# else
##  If no one has initialized this repo we have to download all the files, create the branch and set the upstream and add the gitignore
# 	echo "not exist"
# 	git checkout -b master
# 	scp -r -o StrictHostKeyChecking=no $SITENAME:/sites/$SITENAME $HOME/src/$SITENAME.wpengine
# 	mv $HOME/src/$SITENAME.wpengine/$SITENAME/* $HOME/src/$SITENAME.wpengine/
# 	rm -r $HOME/src/$SITENAME.wpengine/$SITENAME
# 	cp $HOME/src/dev-conf/deployment/default_files/.gitignore .gitignore
# 	git add -A
# 	git commit -m "initial commit"
# 	git push -u origin master
# fi 



##download ignored files, change DB connection string to remote connection so we can grab the password.  then set the connectionstring to localhost
# scp $SITENAME:/sites/$SITENAME/.htaccess $HOME/src/$SITENAME.wpengine/.htaccess
# wp_config="$HOME/src/$SITENAME.wpengine/wp-config.php"
# scp $SITENAME:/sites/$SITENAME/wp-config.php $wp_config
# sed -i'' -e "s/127.0.0.1/$SITENAME.sftp.wpengine.com/g" $wp_config
# DB_PASS=`php -r "include '$wp_config';  echo DB_PASSWORD;"`
# echo $DB_PASS;
# sed -i'' -e "s/$SITENAME.sftp.wpengine.com/localhost/g" $wp_config
# rm $wp_config-e

##download database backup from wp engine website. 
#scp $SITENAME:/sites/$SITENAME/wp-content/mysql.sql $HOME/src/tmp/$SITENAME.sql

##Create empty DB locally, if it doesn't exist
#found_local_db=`mysql -u root -pc0Smo85Log1ca! -Bse "SHOW DATABASES LIKE 'wp_$SITENAME';"`
#if [ "$found_local_db" == "wp_$SITENAME" ]
#then
#	echo "found local db";
#else
#	mysql -u root -pc0Smo85Log1ca! -Bse "
#	create database wp_$SITENAME;
#	CREATE USER '$SITENAME'@'%' IDENTIFIED BY '$DB_PASS';
#	GRANT ALL PRIVILEGES ON wp_$SITENAME.* TO '$SITENAME'@'%';
#	flush privileges;"
#
#	##Restore Local DB
#	mysql -u root -pc0Smo85Log1ca! wp_$SITENAME < $HOME/src/tmp/$SITENAME.sql
#fi


##restore central dev db if it doesn't exist
#found_central_db=`mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! -Bse "SHOW DATABASES LIKE 'wp_$SITENAME';"`
#if [ "$found_central_db" == "wp_$SITENAME" ]
#then
#	echo "found central db";
#else
#	##Create empty DB centrall
#	mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! -Bse "
#	create database wp_$SITENAME;
#	CREATE USER '$SITENAME'@'%' IDENTIFIED BY '$DB_PASS';
#	GRANT ALL PRIVILEGES ON wp_$SITENAME.* TO '$SITENAME'@'%';
#	flush privileges;"

#	##Restore central dev DB
#	mysql -h 192.168.0.14 -u root -pc0Smo85Log1ca! wp_$SITENAME < $HOME/src/tmp/$SITENAME.sql
#fi



##Add SSH info to Filezilla for sFTP
#sed -i'' -e "s/<\/Servers>/<Server> <Host>${SITENAME}.ssh.wpengine.net<\/Host> <Port>22<\/Port> <Protocol>1<\/Protocol> <Type>0<\/Type> <User>${SITENAME}<\/User> <Keyfile>\/Users\/interactivesupply\/.ssh\/id_rsa<\/Keyfile> <Logontype>5<\/Logontype> <TimezoneOffset>0<\/TimezoneOffset> <PasvMode>MODE_DEFAULT<\/PasvMode> <MaximumMultipleConnections>0<\/MaximumMultipleConnections> <EncodingType>Auto<\/EncodingType> <BypassProxy>0<\/BypassProxy> <Name>${SITENAME}.wpengine.com ssh<\/Name> <Comments \/> <Colour>0<\/Colour> <LocalDir>\/Users\/interactivesupply\/src\/${SITENAME}.wpengine<\/LocalDir> <RemoteDir>1 0 5 sites 8 ${SITENAME}<\/RemoteDir> <SyncBrowsing>1<\/SyncBrowsing> <DirectoryComparison>1<\/DirectoryComparison> <\/Server> <\/Servers>/g" ~/.config/filezilla/sitemanager.xml


##update to make sure we have all nginx block
#cd ~/src/dev-conf
#git pull

##create nginx block
# new_nginx_block="$HOME/src/dev-conf/sites-enabled/$SITENAME.wpengine.conf"
# if [ ! -f "$new_nginx_block" ]
# then
# 	cd $HOME/src/dev-conf
# 	cp $HOME/src/dev-conf/sites-enabled/example.wpengine.conf $new_nginx_block
# 	sed -i'' -e "s/example/$SITENAME/g" $new_nginx_block
# 	rm $new_nginx_block-e
# 	git add -a
# 	git commit -m "Adding Website: $SITENAME"
# 	git push
# fi

##restart nginx
#brew services restart nginx

##add domain to SSL settings and regenerate, git add commit and push
#...

##add sql workbench connection
#...
#$HOME/Library/Application Support/MySQL/Workbench/connections.xml


##add DNS entry for $SITENAME.wpengine.com
#local_ip=`ipconfig getifaddr en0` #or en1, maybe
#echo "address=/$SITENAME.wpengine.com/$local_ip" >> /usr/local/etc/dnsmasq.conf


##open newly added website in Chrome
#open -na "Google Chrome" --args --new-window "https://$SITENAME.wpengine.com"

## create database reset scripts
# reset_local_db="$HOME/src/$SITENAME.wpengine/reset_local_db.sh"
# if [ ! -f "$reset_local_db" ]
# then
# 	touch $reset_local_db
# 	chmod +x $reset_local_db
# 	echo "cd $HOME/src/dev-conf/deployment" >> $reset_local_db
# 	echo "./reset_local_db.sh $SITENAME" >> $reset_local_db
# fi

# reset_central_db="$HOME/src/$SITENAME.wpengine/reset_central_db.sh"
# if [ ! -f "$reset_central_db" ]
# then
# 	touch $reset_central_db
# 	chmod +x $reset_central_db
# 	echo "cd $HOME/src/dev-conf/deployment" >> $reset_central_db
# 	echo "./reset_central_db.sh $SITENAME" >> $reset_central_db
# fi

# ##add sublime files
# sublime_project="$HOME/src/$SITENAME.wpengine/$SITENAME.sublime-project"
# if [ ! -f "$sublime_project" ]
# then
# 	cp $HOME/src/dev-conf/deployment/default_files/example.sublime-project $sublime_project
# 	sed -i'' -e "s/example/$SITENAME/g" $sublime_project
# 	rm $sublime_project-e
# fi

# sublime_workspace="$HOME/src/$SITENAME.wpengine/$SITENAME.sublime-workspace"
# if [ ! -f "$sublime_workspace" ]
# then
# 	cp $HOME/src/dev-conf/deployment/default_files/example.sublime-workspace $sublime_workspace
# 	sed -i'' -e "s/example/$SITENAME/g" $sublime_workspace
# 	rm $sublime_workspace-e
# fi


## todo: add these reset scripts to the git ignore
## initialize brand new git repo from WPE
## will the .gitignore needed to be committed (and can it be without conflicts with other repos)
## how to handle websites with multiple domains
## how to handle wp_uploads redirects under nginx
## any node_js or bower stuff to do?
## how to run website error log in the "console" app

