# this will run on the server
KUBERNETES_CONTROL_PLANE=https://dl.k8s.io/v1.13.0/kubernetes-server-linux-amd64.tar.gz

mkdir -p $HOME/components
COMPONENTDIR=$HOME/components

rm -rf $COMPONENTDIR/kubeserver
rm $COMPONENTDIR/kubeserver.tar.gz

curl -L $KUBERNETES_CONTROL_PLANE -o $COMPONENTDIR/kubeserver.tar.gz
mkdir -p $COMPONENTDIR/kubeserver
tar zxvf $COMPONENTDIR/kubeserver.tar.gz -C $COMPONENTDIR/kubeserver
BINDIR=$COMPONENTDIR/kubeserver/kubernetes/server/bin

mkdir -p /etc/kubernetes/config
mkdir -p /var/lib/kubernetes

cp *.kubeconfig /var/lib/kubernetes
cp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem /var/lib/kubernetes

mv $BINDIR/kube-apiserver $BINDIR/kube-controller-manager $BINDIR/kube-scheduler $BINDIR/kubectl /usr/local/bin

apt-get update
apt-get install -y nginx
