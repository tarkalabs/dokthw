#!/usr/bin/env zsh
source ./utils.sh

smartscp =(envsubst < control_plane/etcd.service) controller-01:/etc/systemd/system/etcd.service

run_remote controller-01 control_plane/etcd-remote.sh
