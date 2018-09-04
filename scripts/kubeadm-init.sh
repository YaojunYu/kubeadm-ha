#!/bin/sh
# auther: york

set -eu

cd ../
sh create-config.sh
echo "===copy config to masters==="
: ${NODES:="k8s-m2 k8s-m3"}
for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "mkdir -p /root/.kubeadm/"
  scp config/${NODE}/kubeadm-config.yaml ${NODE}:/root/.kubeadm/kubeadm-config.yaml
done
systemctl start docker
kubeadm init --config config/k8s-m1/kubeadm-config.yaml

export KUBECONFIG=/etc/kubernetes/admin.conf
echo "===install calico==="
# kubectl apply -f calico/
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

cd ./scripts

