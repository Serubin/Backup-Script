#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source `pwd`/backup.conf

# $1 - method
# $2 - url
on_curl(){
    
    POST=""
    if [[ "${3}" != "" ]]; then
        POST="-d \"${3}\""
    fi

    echo ${3} | curl -X ${1} \
        -H "Authorization: Bearer ${online_auth_token}" \
        -H "Content-Type: application/json" \
        -H "X-Pretty-JSON: 1" \
        $([[ "${3}" != "" ]] && echo "-d @-") \
        https://api.online.net/api/v1${2}
}



DATE=$(date +%Y-%m-%d-%Hh%M)
backup_name="${HOST} ${DATE} full backup"


# Create archive
archive_id=$(on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive" "{\"name\": \"${backup_name}\",\"description\": \"${backup_name}\",\"protocols\": [\"SSH\"],\"ssh_keys\": [\"${online_ssh_key_id}\"], \"platforms\": [1]}" | sed -e 's/\"//g') 

ssh_port=$(on_curl "GET" "/storage/c14/safe/${online_safe_id}/archive/${archive_id}/bucket" | python -c "import sys, json; print json.load(sys.stdin)['credentials'][0]['uri'].split(':').pop()")

mkdir -p /mnt/bak 2> /dev/null

sshfs -p ${ssh_port} -o ssh_command='ssh -i /root/.ssh/bak_rsa' c14ssh@${archive_id}.buffer.c14.io:/buffer /mnt/bak

## now loop through the above array
for i in "${!LOCATIONS[@]}"; do
	key="$i"
	value="${LOCATIONS[$i]}"

	echo "Backing up $i !"
	tar -cpzvf  "/mnt/bak/$key-$DATE.tar.gz" "$value"
done

mysqldump -u root -p$mysqlpass --all-databases > /mnt/bak/SQL-$DATE.sql

fusermount -u /mnt/bak

rmdir /mnt/bak 2> /dev/null

