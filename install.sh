#!/bin/bash

echo "Root or sudo is required to install most packages. Please sudo up:"                       
sudo echo 'Running in sudo mode'

echo "Please enter your prefered install location (defaults to \"/backup/\")"
echo ""
read -p "Install location" script_path
if [[ ${script_path} == "" ]]; then
    script_path="/backup"
fi

sudo mkdir -p $script_path 2> /dev/null

if [ ! -r "${script_path}/backup.conf" ]; then
    cp backup.conf.example ${script_path}/backup.conf
fi

sudo editor ${script_path}/backup.conf

sudo cp -f on_curl.func.sh ${script_path}
sudo cp -f open_archive.sh ${script_path}
sudo cp -f close_archive.sh ${script_path}
sudo cp -f backup.sh ${script_path}




sudo $(  (crontab -u ${USER} -l ; echo " 1 0          *   *   1     /bin/bash /backup/open_archive.sh > /dev/null") | crontab -u ${USER} -)
sudo $(  (crontab -u ${USER} -l ; echo " 1 23         *   *   7     /bin/bash /backup/close_archive.sh > /dev/null") | crontab -u ${USER} -)
sudo $(  (crontab -u ${USER} -l ; echo " 0 2,8,14,22  *   *   *     /bin/bash /backup/backup.sh > /dev/null") | crontab -u ${USER} -)


