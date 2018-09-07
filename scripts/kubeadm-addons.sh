#!/bin/sh
# auther: york

set -eu

cd ../

export KUBECONFIG=/etc/kubernetes/admin.conf
echo "===install calico==="
kubectl apply -f calico/
echo "===install metrics-server==="
kubectl apply -f metrics-server/
echo "===install heapster==="
kubectl apply -f heapster/
echo "===install dashboard==="
kubectl apply -f dashboard/
echo "===install traefik==="
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=k8s-master-lb"
# kubectl -n kube-system create secret generic traefik-cert --from-file=tls.key --from-file=tls.crt
# kubectl apply -f traefik/
echo "===install istio==="
kubectl apply -f istio/
echo "===install prometheus==="
kubectl apply -f prometheus/

kubectl get all --all-namespaces -o wide

cd ./scripts