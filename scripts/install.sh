#!/bin/sh
# auther: york

set -eu

echo ""
echo "===clean all==="
sh clean-all.sh

echo ""
echo "===set up masters' firewall==="
export NODES="k8s-m1 k8s-m2 k8s-m3"
export PORTS="16443 6443 4001 2379-2380 10250 10251 10252 10255 30000-32767"
sh firewall-setup.sh

echo ""
echo "===set up nodes' firewall==="
export NODES="k8s-n1"
export PORTS="10250 30000-32767"
sh firewall-setup.sh

echo ""
echo "===install kubernetes: kubelet,kubeadm,kubectl==="
export NODES="k8s-m1 k8s-m2 k8s-m3 k8s-n1"
sh install-kube.sh

echo ""
echo "===install keepalived==="
export NODES="k8s-m1 k8s-m2 k8s-m3"
sh install-keepalived.sh

echo ""
echo "===kubeadm set up==="
sh kubeadm-up.sh


