#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/on_curl.func.sh

DATE=$(date +%Y-%m-%d)
backup_name="${HOST} ${DATE} full backup"

# Rearchive data
export archive_id=$(on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/archive" "{}" | sed -e 's/"//g')

perl -p -i -e 's/online_archive_id=".*"/online_archive_id="$ENV{archive_id}"/g;' $(pwd)/backup.conf

# Delete ssh information file
rm $(pwd)/ssh_info

