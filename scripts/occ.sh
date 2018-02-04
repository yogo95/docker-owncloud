#!/usr/bin/env bash
set -e

oc_apache_path=$(cat /opt/owncloud/oc-apache-path.txt)
htuser='apache'
htgroup='apache'

pushd $oc_apache_path >/dev/null
  su-exec $htuser php $oc_apache_path/occ ${@}
popd >/dev/null
