#!/bin/bash

script_path="/backup/"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source ${script_path}/backup.conf
source ${script_path}/on_curl.func.sh

DATE=$(date +%Y-%m-%d)
backup_name="${HOSTNAME} - Current"

# Open archive
export online_archive_id=$(on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive" "{\"name\": \"${backup_name}\", \"description\": \"{$HOSTNAME}\", \"protocols\": [\"SSH\"],\"ssh_keys\": [\"${online_ssh_key_id}\"], \"platforms\": [1]}" | sed -e 's/"//g')


perl -p -i -e 's/online_archive_id=".*"/online_archive_id="$ENV{online_archive_id}"/g;' ${script_path}/backup.conf


