#!/bin/bash

declare -A LOCATIONS

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#BACKUP LOCATIONS#
LOCATIONS[Homes]="/home/"
LOCATIONS[WWW]="/var/www/"
LOCATIONS[ApacheConf]="/etc/apache2"

dir="/backup/"

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

mysqldump -u root -p --all-databases > $BACKUP/SQL-$DATE.sql

# Protect files
find $BACKUP -exec chmod 640 {} \;
find $BACKUP -exec chgrp user {} \;
