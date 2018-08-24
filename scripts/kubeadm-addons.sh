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

kubectl get all --all-namespaces -o wide

cd ./scripts