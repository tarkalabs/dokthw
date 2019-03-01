#!/usr/bin/env zsh
function smartscp() {
  scp -F =(envsubst < ssh_config) $*
}

smartscp certs/ca.pem \
  certs/ca-key.pem \
  certs/kubernetes-key.pem  \
  certs/kubernetes.pem  \
  certs/service-account-key.pem  \
  certs/service-account.pem  \
  controller-01:.

smartscp certs/ca.pem \
  certs/node-01.pem  \
  certs/node-01-key.pem  \
  node-01:.

smartscp certs/ca.pem \
  certs/node-02.pem  \
  certs/node-02-key.pem  \
  node-02:.
