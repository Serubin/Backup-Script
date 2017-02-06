#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/on_curl.func.sh

DATE=$(date +%Y-%m-%d)
backup_name="${HOST} ${DATE} full backup"

fusermount -u ${mount_point}

# Create archive
on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/archive" "{}"

