export KUBECONFIG=`pwd`/kubeconfigs/dev.kubeconfig
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f coredns/coredns.yaml
