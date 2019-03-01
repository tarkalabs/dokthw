if [ ! -f /etc/nginx/sites-enabled/health_check.conf ]; then
  ln -s /etc/nginx/sites-available/health_check.conf /etc/nginx/sites-enabled/health_check.conf
fi

systemctl daemon-reload
systemctl enable kube-apiserver kube-controller-manager kube-scheduler
systemctl start kube-apiserver kube-controller-manager kube-scheduler
systemctl reload nginx

kubectl get componentstatuses --kubeconfig /var/lib/kubernetes/admin.kubeconfig
kubectl apply -f node_authorization.yaml
