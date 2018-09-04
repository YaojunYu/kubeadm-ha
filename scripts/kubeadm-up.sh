#!/bin/sh
# auther: york

set -eu

echo "===init first master==="
export NODES="k8s-m2 k8s-m3"
sh kubeadm-init.sh

echo "===sleep 120s wait pod etc-k8s-m1 up==="
sleep 120

echo "===install other masters==="
export NODES="k8s-m2 k8s-m3"
sh kubeadm-ha.sh

echo "===install addons on masters==="
sh kubeadm-addons.sh

echo "===join all nodes==="
export NODES="k8s-n1"
sh kubeadm-join.sh
