#!/bin/bash

###
# Backup.sh - rysnc backup script for online.net
# @Serubin
# MIT License
###

script_path="/backup/"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source ${script_path}/backup.conf
source ${script_path}/on_curl.func.sh

# Fetch bucket info
bucket=$(on_curl "GET" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/bucket")

# Retreive and dismantle ssh infomation
ssh_info=$(echo $bucket | python -c "import sys, json; retval = json.load(sys.stdin)['credentials'][0]['uri'].replace('ssh://', '').split(':'); print ' '.join(retval)")
ssh_info=($ssh_info)

# SSH info
ssh_uri=${ssh_info[0]}
ssh_port=${ssh_info[1]}


## now loop through the above array
for i in "${!LOCATIONS[@]}"; do
	key="$i"
	value="${LOCATIONS[$i]}"

	echo "Backing up $i !"
    rsync -avR --inplace -e "ssh -p ${ssh_port} -i /root/.ssh/bak_rsa -o \"StrictHostKeyChecking no\"" ${value} ${ssh_uri}:/buffer/
done

# Rsync sql dump
mysqldump -u root -p${mysqlpass} --all-databases > /tmp/mysql_dump.sql 

rsync -aR --inplace -e "ssh -p ${ssh_port} -i /root/.ssh/bak_rsa -o \"StrictHostKeyChecking no\"" /
tmp/mysql_dump.sql ${ssh_uri}:/buffer/

rm /tmp/mysql_dump.sql

