# this runs on the server
K8S_NODE=https://dl.k8s.io/v1.13.0/kubernetes-node-linux-amd64.tar.gz
CNI_PLUGINS_URL=https://github.com/containernetworking/plugins/releases/download/v0.7.1/cni-plugins-amd64-v0.7.1.tgz
mkdir -p $HOME/components
COMPONENTDIR=$HOME/components
HOSTNAME=$(hostname -s)

# Kubernetes node stuff
rm -rf $COMPONENTDIR/kubenode
rm $COMPONENTDIR/kubenode.tar.gz
curl -L $K8S_NODE -o $COMPONENTDIR/kubenode.tar.gz
mkdir -p $COMPONENTDIR/kubenode
tar zxvf $COMPONENTDIR/kubenode.tar.gz -C $COMPONENTDIR/kubenode
BINDIR=$COMPONENTDIR/kubenode/kubernetes/node/bin
mv $BINDIR/kubelet $BINDIR/kubectl $BINDIR/kube-proxy /usr/local/bin
mkdir -p /var/lib/kubelet /var/lib/kube-proxy /var/lib/kubernetes /var/run/kubernetes /run/flannel

# CNI stuff
curl -L $CNI_PLUGINS_URL -o $COMPONENTDIR/cni-plugins.tar.gz
mkdir -p /opt/cni/bin /etc/cni/net.d
tar xzvf $COMPONENTDIR/cni-plugins.tar.gz -C /opt/cni/bin

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common socat conntrack ipset

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

docker run hello-world

cp ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
cp ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
cp kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cp ca.pem /var/lib/kubernetes


