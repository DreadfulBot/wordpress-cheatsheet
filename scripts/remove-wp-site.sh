#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Arguments: <site_name>"
	exit 2
fi

db_name=${1//-/_}

mysql -uroot -proot -e "DROP DATABASE $db_name"
rm -r /var/www/$1

sudo -- sh -c "sudo sed -i \"\" \"s/127.0.0.1.*dev.$1//g\" /etc/hosts"

cd /opt/homebrew/etc/nginx
rm servers/dev.$1.conf