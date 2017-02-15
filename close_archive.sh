#!/bin/bash

script_path="/backup/"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source ${script_path}/backup.conf
source ${script_path}/on_curl.func.sh

DATE=$(date +%Y-%m-%d)

# Rearchive data
on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/archive" "{}" 
on_curl "PATCH" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}" "{\"name\": \"${HOSTNAME} - ${DATE}\"}" # Update name

