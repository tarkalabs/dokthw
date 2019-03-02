#!/usr/bin/env zsh


function set_cluster_with_addr() {
  kubectl config set-cluster dokthw \
    --certificate-authority=certs/ca.pem \
    --embed-certs=true \
    --server=${1} \
    --kubeconfig=kubeconfigs/${2}.kubeconfig
}

# usage: set_cluster config_name 
function set_cluster() {
  set_cluster_with_addr https://${CLUSTERADDR}/ ${1}
}

# usage: set_user username keyname config_name
function set_user_custom() {
  kubectl config set-credentials ${1} \
    --client-certificate=certs/${2}.pem \
    --client-key=certs/${2}-key.pem \
    --embed-certs=true \
    --kubeconfig=kubeconfigs/${3}.kubeconfig

    kubectl config set-context default \
      --cluster=dokthw \
      --user=${1} \
      --kubeconfig=kubeconfigs/${3}.kubeconfig

    kubectl config use-context default --kubeconfig=kubeconfigs/${3}.kubeconfig
}

function set_user() {
  set_user_custom ${1} ${1} ${1}
}

function node_certs() {
  for instance in node-01 node-02; do
    set_cluster ${instance}
    set_user_custom system:node:${instance} ${instance} ${instance}
  done
}

function proxy_certs() {
  set_cluster kube-proxy
  set_user_custom system:kube-proxy kube-proxy kube-proxy
}

function controller_manager_certs() {
  set_cluster_with_addr https://127.0.0.1:6443 kube-controller-manager
  set_user_custom system:kube-controller-manager kube-controller-manager kube-controller-manager
}

function scheduler_certs() {
  set_cluster_with_addr https://127.0.0.1:6443 kube-scheduler
  set_user_custom system:kube-scheduler kube-scheduler kube-scheduler
}

function admin_certs() {
  set_cluster_with_addr https://127.0.0.1:6443 admin
  set_user admin
}

function dev_access() {
  set_cluster dev
  set_user_custom admin admin dev
}

node_certs
proxy_certs
controller_manager_certs
scheduler_certs
admin_certs
dev_access
