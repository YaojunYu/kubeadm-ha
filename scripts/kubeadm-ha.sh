#!/bin/sh
# auther: york

set -eu

echo "===install the sencond master==="
ssh k8s-m2 < kubeadm-m2.sh
echo "===install the third master==="
ssh k8s-m3 < kubeadm-m3.sh