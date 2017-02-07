#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

source $(pwd)/backup.conf
source $(pwd)/on_curl.func.sh

DATE=$(date +%Y-%m-%d)
backup_name="${HOSTNAME} - Current"

# Open archive
export online_archive_id=$(on_curl "POST" "/storage/c14/safe/${online_safe_id}/archive" "{\"name\": \"${backup_name}\", \"description\": \"{$HOSTNAME}\", \"protocols\": [\"SSH\"],\"ssh_keys\": [\"${online_ssh_key_id}\"], \"location_id\": \"${location}\"}" | sed -e 's/"//g')


perl -p -i -e 's/online_archive_id=".*"/online_archive_id="$ENV{online_archive_id}"/g;' $(pwd)/backup.conf

# Fetch bucket info
bucket=$(on_curl "GET" "/storage/c14/safe/${online_safe_id}/archive/${online_archive_id}/bucket")

# Retreive and dismantle ssh infomation
ssh_info=$(echo $bucket | python -c "import sys, json; retval = json.load(sys.stdin)['credentials'][0]['uri'].replace('ssh://', '').split(':'); print ' '.join(retval)")
ssh_info=($ssh_info)


# Write to ssh information file
touch $(pwd)/ssh_info

cat << EOF > $(pwd)/ssh_info
    #!/bin/bash
    ssh_uri=${ssh_info[0]}
    ssh_port=${ssh_info[1]}
EOF

