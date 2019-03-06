#!/bin/bash

function move_certs() {
  mv $1.pem $1-key.pem certs
  rm $1.csr
}

function clear_certs() {
  rm -rf certs/*
}
clear_certs

cfssl gencert -initca csrs/ca-csr.json | cfssljson -bare ca
move_certs ca

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  csrs/admin-csr.json | cfssljson -bare admin
move_certs admin

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -hostname=node-01,$NODE01IP \
  -profile=kubernetes \
  csrs/node-01-csr.json | cfssljson -bare node-01
move_certs node-01

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -hostname=node-02,$NODE02IP \
  -profile=kubernetes \
  csrs/node-02-csr.json | cfssljson -bare node-02
move_certs node-02


cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  csrs/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
move_certs kube-controller-manager


cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  csrs/kube-proxy-csr.json | cfssljson -bare kube-proxy
move_certs kube-proxy

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  csrs/kube-scheduler-csr.json | cfssljson -bare kube-scheduler
move_certs kube-scheduler

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  csrs/service-account-csr.json | cfssljson -bare service-account
move_certs service-account

cfssl gencert \
  -ca=certs/ca.pem \
  -ca-key=certs/ca-key.pem \
  -config=csrs/ca-config.json \
  -profile=kubernetes \
  -hostname=10.32.0.1,127.0.0.1,localhost,$CONTROLLERIP,$CLUSTERIP,$CLUSTERADDR,kubernetes.default \
  csrs/kubernetes-csr.json | cfssljson -bare kubernetes
move_certs kubernetes
