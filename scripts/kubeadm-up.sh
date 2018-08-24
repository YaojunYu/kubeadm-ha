#!/bin/sh
# auther: york

set -eu

echo "===init first master==="
export NODES="${MASTERS}"
sh kubeadm-init.sh

echo "===sleep 120s wait pod etc-k8s-m1 up==="
sleep 120

echo "===install other masters==="
export NODES="${MASTERS}"
sh kubeadm-ha.sh

echo "===install addons on masters==="
sh kubeadm-addons.sh

echo "===join all nodes==="
export NODES="${MINIONS}"
sh kubeadm-join.sh
