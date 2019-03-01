#!/usr/bin/env zsh
source ./utils.sh
run_remote controller-01 control_plane/prepare-environment.sh
smartscp =(envsubst < control_plane/kube-apiserver.service) controller-01:/etc/systemd/system/kube-apiserver.service
smartscp control_plane/kube-controller-manager.service controller-01:/etc/systemd/system/kube-controller-manager.service
smartscp control_plane/kube-scheduler-config.yaml controller-01:/etc/kubernetes/config/kube-scheduler.yaml
smartscp control_plane/kube-scheduler.service controller-01:/etc/systemd/system/kube-scheduler.service
smartscp =(envsubst < control_plane/health_check.conf) controller-01:/etc/nginx/sites-available/health_check.conf
run_remote controller-01 control_plane/start-services.sh
