#!/bin/sh
#

set -eu

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
