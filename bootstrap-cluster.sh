#!/usr/bin/env zsh
if [[ -z "${NODE01IP}" ]] || [[ -z "${NODE02IP}" ]] || [[ -z "${CONTROLLERIP}" ]] || [[ -z "${CLUSTERIP}" ]] || [[ -z "${CLUSTERADDR}" ]]; then
  echo "required environment variables are not set"
  exit 2
fi

echo "hang on..."
./utils.sh >> bootstrap.log 2>&1
echo "generating certs..."
./generate-certs.sh >> bootstrap.log 2>&1
echo "copying certs to cluster..."
./copy-certs.sh >> bootstrap.log 2>&1
echo "generating kubeconfig files ..."
./generate-kubeconfigs.sh >> bootstrap.log 2>&1
echo "copying kubeconfig files to cluster ..."
./copy-configs.sh >> bootstrap.log 2>&1
echo "setting up etcd ..."
./setup-etcd.sh >> bootstrap.log 2>&1
sleep 5
echo "setting up control plane ..."
./setup-control-plane.sh >> bootstrap.log 2>&1
echo "setting up worker nodes ..."
./setup-nodes.sh >> bootstrap.log 2>&1
echo "setting up networking ..."
./setup-networking.sh >> bootstrap.log 2>&1

echo "all set for take off"
echo "run KUBECONFIG=kubeconfigs/dev.kubeconfig kubectl get pods --all-namespaces"
