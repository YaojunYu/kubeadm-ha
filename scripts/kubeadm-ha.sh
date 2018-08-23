#!/bin/sh
# auther: york

set -eu

: ${K8S_M2:="k8s-m2"}
: ${K8S_M3:="k8s-m3"}

ssh ${K8S_M2} < kubeadm-m2.sh
ssh ${K8S_M3} < kubeadm-m3.sh