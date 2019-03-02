#!/usr/bin/env zsh
source ./utils.sh

for instance in node-01 node-02; do
  #run_remote ${instance} nodes/prepare-environment.sh
  #smartscp nodes/99-loopback.conf ${instance}:/etc/cni/net.d/99-loopback.conf
  #smartscp =(HOSTNAME=${instance} envsubst < nodes/kubelet-config.yaml) ${instance}:/var/lib/kubelet/kubelet-config.yaml
  #smartscp nodes/kubelet.service ${instance}:/etc/systemd/system/kubelet.service
  #smartscp nodes/kube-proxy-config.yaml ${instance}:/var/lib/kube-proxy/kube-proxy-config.yaml
  #smartscp nodes/kube-proxy.service ${instance}:/etc/systemd/system/kube-proxy.service
  run_remote ${instance} nodes/start-services.sh
done
