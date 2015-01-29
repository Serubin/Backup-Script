#!/bin/bash
declare -A LOCATIONS

############### CONFIG ###############
dir="/backup/" # Backup location

mysqlpass="pass" # Mysql root password

fileperm=660 # Sets tar.gz files to this permission
useraccess="user" # Grant grp permission to this user (own stays root)

#BACKUP LOCATIONS#
LOCATIONS[Homes]="/home/"
LOCATIONS[WWW]="/var/www/"
LOCATIONS[ApacheConf]="/etc/apache2"
############## CONFIG END ##############

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

DATE=$(date +%Y-%m-%d-%Hh%M)

BACKUP=$dir"full_$DATE"

mkdir $BACKUP

## now loop through the above array
for i in "${!LOCATIONS[@]}"; do
	key="$i"
	value="${LOCATIONS[$i]}"

	echo "Backing up $i !"
	tar -czf  "$BACKUP/$key-$DATE.tar.gz" "$value" | pv $BACKUP/$key-$DATE.tar.gz
done

mysqldump -u root -p$mysqlpass --all-databases > $BACKUP/SQL-$DATE.sql

# Protect files
find $BACKUP -exec chmod $fileperm {} \;
find $BACKUP -exec chgrp $useraccess {} \;
