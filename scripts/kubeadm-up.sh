#!/bin/sh
# auther: york

set -eu

sh ../create-config.sh
echo "===copy config to masters==="
for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "mkdir -p /root/.kubeadm/"
  scp ../config/${NODE}/kubeadm-config.yaml ${NODE}:/root/.kubeadm/kubeadm-config.yaml
done

sh kubeadm-init.sh

echo "===copy certs to other masters==="
: ${NODES:="k8s-m2 k8s-m3"}
for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "mkdir -p /etc/kubernetes/pki/etcd/"
  scp /etc/kubernetes/pki/ca.crt ${NODE}:/etc/kubernetes/pki/ca.crt
  scp /etc/kubernetes/pki/ca.key ${NODE}:/etc/kubernetes/pki/ca.key
  scp /etc/kubernetes/pki/sa.key ${NODE}:/etc/kubernetes/pki/sa.key
  scp /etc/kubernetes/pki/sa.pub ${NODE}:/etc/kubernetes/pki/sa.pub
  scp /etc/kubernetes/pki/front-proxy-ca.crt ${NODE}:/etc/kubernetes/pki/front-proxy-ca.crt
  scp /etc/kubernetes/pki/front-proxy-ca.key ${NODE}:/etc/kubernetes/pki/front-proxy-ca.key
  scp /etc/kubernetes/pki/etcd/ca.crt ${NODE}:/etc/kubernetes/pki/etcd/ca.crt
  scp /etc/kubernetes/pki/etcd/ca.key ${NODE}:/etc/kubernetes/pki/etcd/ca.key
  scp /etc/kubernetes/admin.conf ${NODE}:/etc/kubernetes/admin.conf
done

echo "===sleep 120s wait pod etc-k8s-m1 up==="
sleep 120

echo "===install other masters==="
sh kubeadm-ha.sh

kubectl taint nodes --all node-role.kubernetes.io/master-

echo "===install calico==="
