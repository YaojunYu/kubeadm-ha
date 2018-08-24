#!/bin/sh
# auther: york

set -eu

: ${MASTERS:="k8s-m1 k8s-m2 k8s-m3"}
: ${MINIONS:="k8s-n1"}
: ${ALL:="${MASTERS} ${MINIONS}"}

echo ""
echo "===clean all==="
export NODES="${ALL}"
sh clean-all.sh

echo ""
echo "===set up masters' firewall==="
export NODES="${MASTERS}"
export PORTS="16443 6443 4001 2379-2380 10250 10251 10252 10255 30000-32767"
sh firewall-setup.sh

echo ""
echo "===set up nodes' firewall==="
export NODES="${MINIONS}"
export PORTS="10250 30000-32767"
sh firewall-setup.sh

echo ""
echo "===install kubernetes: kubelet,kubeadm,kubectl==="
export NODES="${ALL}"
sh install-kube.sh

echo ""
echo "===install keepalived==="
export NODES="${MASTERS}"
sh install-keepalived.sh

echo ""
echo "===kubeadm set up==="
sh kubeadm-up.sh




