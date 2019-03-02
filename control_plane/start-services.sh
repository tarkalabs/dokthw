if [ ! -f /etc/nginx/sites-enabled/health_check.conf ]; then
  ln -s /etc/nginx/sites-available/health_check.conf /etc/nginx/sites-enabled/health_check.conf
fi

systemctl daemon-reload
systemctl enable kube-apiserver kube-controller-manager kube-scheduler
systemctl restart kube-apiserver kube-controller-manager kube-scheduler
systemctl reload nginx

echo "Waiting for cluster to come up..."
sleep 10

kubectl get componentstatuses --kubeconfig /var/lib/kubernetes/admin.kubeconfig
kubectl apply -f node_authorization.yaml
