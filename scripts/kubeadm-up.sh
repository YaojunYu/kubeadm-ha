#!/bin/sh
# auther: york

set -eu

sh kubeadm-init.sh

echo "===sleep 120s wait pod etc-k8s-m1 up==="
sleep 120

echo "===install other masters==="
sh kubeadm-ha.sh

kubectl taint nodes --all node-role.kubernetes.io/master-