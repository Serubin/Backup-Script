#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/ssh_info


## now loop through the above array
for i in "${!LOCATIONS[@]}"; do
	key="$i"
	value="${LOCATIONS[$i]}"

	echo "Backing up $i !"
    rsync -avR --inplace -e "ssh -p ${ssh_port} -i /root/.ssh/bak_rsa" ${value} ${ssh_uri}:/buffer/
done

mysqldump -u root -p${mysqlpass} --all-databases > ${mount_point}/mysql_dump.sql # TODO move to rsync

