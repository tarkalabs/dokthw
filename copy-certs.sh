#!/usr/bin/env zsh

source ./utils.sh

smartscp certs/ca.pem \
  certs/ca-key.pem \
  certs/kubernetes-key.pem  \
  certs/kubernetes.pem  \
  certs/service-account-key.pem  \
  certs/service-account.pem  \
  controller-01:.

for instance in node-01 node-02; do
  smartscp certs/ca.pem \
    certs/${instance}.pem  \
    certs/${instance}-key.pem  \
    ${instance}:.
done

for instance in node-01 node-02 controller-01; do
  smartscp =(envsubst < hosts) ${instance}:~/hosts
  smartssh ${instance} "cat hosts >> /etc/hosts"
done
