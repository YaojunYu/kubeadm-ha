#!/bin/sh
# auther: york

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3 k8s-n1"}
for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "rm -rf /root/.kubeadm"
  ssh ${NODE} "kubeadm reset -f"
  ssh ${NODE} "systemctl daemon-reload && systemctl disable docker && systemctl stop docker"
  ssh ${NODE} "systemctl daemon-reload && systemctl disable kubelet && systemctl stop kubelet"
  ssh ${NODE} "yum remove -y kubeadm kubelet kubectl"
done