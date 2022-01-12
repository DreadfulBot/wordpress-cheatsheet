#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Arguments: <site_name>"
	exit 2
fi

if [[ $1 == *"-"* ]]; then
	echo "Sitename should not contain symbol -"
	exit 2
fi

mysql -uroot -proot -e "CREATE DATABASE $1 CHARACTER SET utf8 COLLATE utf8_general_ci"
mkdir /var/www/$1
cd /var/www/$1
wp core download --allow-root

# put your credentials to db in this line
wp config create --dbhost=127.0.0.1 --dbname=$1 --dbuser=root --dbpass=root --allow-root --extra-php <<PHP

define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);

PHP

wp core install --url=dev.$1 --title=$1 --admin_user=admin --admin_password=123456 --admin_email=zorg1995@yandex.ru --allow-root

# also, set up folder rights to your system user
chown -R riskyworks:admin /var/www/$1
chmod 777 /var/www/$1/wp-content

# alias for dev.%SITENAME% will be added to your hosts file
sudo -- sh -c "echo \"127.0.0.1	dev.$1\" >> /etc/hosts"

cd /opt/homebrew/etc/nginx

sed -e "s/\${name}*/$1/g" dev.wp.conf >> servers/dev.$1.conf
chown riskyworks:admin servers/dev.$1.conf 

nginx -t
