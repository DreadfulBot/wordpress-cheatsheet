#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Arguments: <site_name>"
	exit 2
fi

if [[ $1 == *"-"* ]]; then
	echo "Sitename should not contain symbol -"
	exit 2
fi

mysql -uroot -proot -e "DROP DATABASE $1"
rm -r /var/www/$1

sudo -- sh -c "sudo sed -i \"\" \"s/127.0.0.1.*dev.$1//g\" /etc/hosts"

cd /opt/homebrew/etc/nginx
rm servers/dev.$1.conf