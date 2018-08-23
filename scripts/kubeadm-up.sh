#!/bin/sh
# auther: york

set -eu

sh kubeadm-init.sh

echo "===copy certs to other masters==="
: ${NODES:="k8s-m2 k8s-m3"}
for NODE in ${NODES}; do
  echo "---${NODE}---"
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

sh kubeadm-ha.sh