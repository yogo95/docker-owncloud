#!/usr/bin/env bash

LOG_PREFIX="apache"

# Initialize apache2
apache_server_name=$(hostname)
if [ ! -z "$APACHE_SERVER_NAME" ];  then
    apache_server_name=$APACHE_SERVER_NAME
fi

echo "[$LOG_PREFIX] Setting server name to '$apache_server_name'"
sed -i "s/#ServerName www.example.com:80/ServerName $apache_server_name/" /etc/apache2/httpd.conf
sed -i "s/#\?ServerSignature .*/ServerSignature Off/" /etc/apache2/httpd.conf
sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/httpd.conf

echo "[$LOG_PREFIX] Enforce directory /run/apache2 to exists"
mkdir -p /run/apache2

echo "[$LOG_PREFIX] Clear old process pid"
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid


