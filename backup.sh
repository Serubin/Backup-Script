#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf

## now loop through the above array
for i in "${!LOCATIONS[@]}"; do
	key="$i"
	value="${LOCATIONS[$i]}"

	echo "Backing up $i !"
	rsync -ra "${value}" "${mount_point}"
done

mysqldump -u root -p${mysqlpass} --all-databases > ${mount_point}/mysql_dump.sql

