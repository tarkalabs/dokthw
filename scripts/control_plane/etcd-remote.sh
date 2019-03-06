# this file runs on the server

systemctl stop etcd
systemctl disable etcd
mkdir -p $HOME/components
COMPONENTDIR=$HOME/components
rm -rf $COMPONENTDIR/etcd-download-test
rm $COMPONENTDIR/etcd*.tar.gz

curl -L https://github.com/etcd-io/etcd/releases/download/v3.3.12/etcd-v3.3.12-linux-amd64.tar.gz -o $COMPONENTDIR/etcd-v3.3.12-linux-amd64.tar.gz
mkdir -p $COMPONENTDIR/etcd-download-test
tar xzvf $COMPONENTDIR/etcd-v3.3.12-linux-amd64.tar.gz -C $COMPONENTDIR/etcd-download-test --strip-components=1
rm -f $COMPONENTDIR/etcd-v3.3.12-linux-amd64.tar.gz

$COMPONENTDIR/etcd-download-test/etcd --version
ETCDCTL_API=3 $COMPONENTDIR/etcd-download-test/etcdctl version

cp $COMPONENTDIR/etcd-download-test/etcd /usr/local/bin
cp $COMPONENTDIR/etcd-download-test/etcdctl /usr/local/bin

mkdir -p /etc/etcd /var/lib/etcd
cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/

systemctl daemon-reload
systemctl enable etcd
systemctl start etcd

echo "waiting for etcd to start"
sleep 3

ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem
