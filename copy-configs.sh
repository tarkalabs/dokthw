#!/usr/bin/env zsh

source ./utils.sh

smartscp kubeconfigs/admin.kubeconfig \
  kubeconfigs/kube-controller-manager.kubeconfig \
  kubeconfigs/kube-scheduler.kubeconfig \
  controller-01:.

for instance in node-01 node-02; do
  smartscp kubeconfigs/bootstrap.kubeconfig kubeconfigs/kube-proxy.kubeconfig ${instance}:.
done
