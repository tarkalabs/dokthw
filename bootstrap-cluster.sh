#!/usr/bin/env zsh
if [[ -z "${NODE01IP}" ]] || [[ -z "${NODE02IP}" ]] || [[ -z "${CONTROLLERIP}" ]] || [[ -z "${CLUSTERIP}" ]] || [[ -z "${CLUSTERADDR}" ]]; then
  echo "required environment variables are not set"
  exit 2
fi

echo "hang on..."
source ./utils.sh >> bootstrap.log
echo "generating certs..."
source ./generate-certs.sh >> boostrap.log
echo "copying certs to cluster..."
source ./copy-certs.sh >> bootstrap.log
echo "generating kubeconfig files ..."
source ./generate-kubeconfigs.sh >> boostrap.log
echo "copying kubeconfig files to cluster ..."
source ./copy-configs.sh >> bootstrap.log
echo "setting up etcd ..."
source ./setup-etcd.sh >> bootstrap.log
echo "setting up control plane ..."
source ./setup-control-plane.sh >> bootstrap.log
echo "setting up worker nodes ..."
source ./setup-nodes.sh >> bootstrap.log
echo "setting up networking ..."
source ./setup-networking.sh >> bootstrap.log

echo "all set for take off"
echo "run KUBECONFIG=kubeconfigs/dev.kubeconfig kubectl get pods --all-namespaces"
