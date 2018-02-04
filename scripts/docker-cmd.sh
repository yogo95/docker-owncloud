#!/usr/bin/env bash

source /opt/zrim-everything/initialize-php7.sh
source /opt/zrim-everything/initialize-apache2.sh
source /opt/zrim-everything/initialize-owncloud.sh

if [ -d "/entrypoint.d" ]; then
    for f in /entrypoint.d/*.sh
    do
        echo "Source the entry point: '/entrypoint.d/$f"
        source ${f}
    done
fi

echo "[main] Starting apache2"
exec httpd -D FOREGROUND
