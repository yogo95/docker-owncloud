#!/usr/bin/env bash

oc_version=$(cat /opt/owncloud/version.live.txt)
oc_path=/opt/owncloud/owncloud-$oc_version
oc_apps_path=$oc_path/apps
oc_apache_path=$(cat /opt/owncloud/oc-apache-path.txt)
oc_apache_apps_path=$oc_apache_path/apps

htuser='apache'
htgroup='apache'

ensure_oc_path_exists() {
    if [ ! -d "$oc_path" ]; then
        echo "Cannot find the owncloud path $oc_path"
        exit 1
    fi
}

if [ -z "$OC_DISABLE_ENSURE_APPS" ]; then
    ensure_oc_path_exists

    if [ -d "$oc_apps_path" ]; then
        for p in $(find $oc_apps_path/ -type d -mindepth 1 -maxdepth 1); do
            app_name=$(basename $p)
            if [ ! -d "$oc_apache_apps_path/$app_name" ]; then
                echo "Copy the application $app_name ('$p' -> '$oc_apache_apps_path/$app_name')"
                cp -a $p $oc_apache_apps_path/$app_name
            else
                echo "Application $app_name exists, nothing to do"
            fi
        done;
    else
        echo "Cannot find $oc_apps_path"
    fi
fi

if [ -z "$OC_DISABLE_ENSURE_APPS_RIGHT" ]; then
    if [ -d "$oc_apache_apps_path" ]; then
        echo "Change owner of '$oc_apache_apps_path'"
        chown -R ${htuser}:${htgroup} $oc_apache_apps_path
    else
        echo "Cannot find the application directory '$oc_apache_apps_path'"
    fi
fi

if [ -z "$OC_DISABLE_ENSURE_CONFIG_RIGHT" ]; then
    if [ -d "$oc_apache_apps_path" ]; then
        if [ -f "$oc_apache_path/config/config.php" ]; then
            chown ${htuser}:${htgroup} $oc_apache_path/config/config.php
        else
            echo "Cannot find $oc_apache_path/config/config.php"
        fi
    else
        echo "Cannot find the application directory '$oc_apache_apps_path'"
    fi
fi
