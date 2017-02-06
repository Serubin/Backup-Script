#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/on_curl.func.sh

DATE=$(date +%Y-%m-%d)
backup_name="${HOST} ${DATE} full backup"


# Create archive
on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/unarchive" "{\"protocols\": [\"SSH\"],\"ssh_keys\": [\"${online_ssh_key_id}\"], \"location_id\": [1]}"

ssh_port=$(on_curl "GET" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/bucket" | python -c "import sys, json; print json.load(sys.stdin)['credentials'][0]['uri'].split(':').pop()")

mkdir -p /mnt/bak 2> /dev/null

sshfs -p ${ssh_port} -o ssh_command='ssh -i /root/.ssh/bak_rsa' c14ssh@${archive_id}.buffer.c14.io:/buffer /mnt/bak

