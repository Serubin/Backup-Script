#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/on_curl.func.sh

DATE=$(date +%Y-%m-%d)

# Rearchive data
on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/archive" "{}" 
on_curl "PATCH" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}" "{\"name\": \"${HOSTNAME} - ${DATE}\"}" # Update name

# Delete ssh information file
rm $(pwd)/ssh_info

