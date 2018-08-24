#!/bin/sh
# auther: york

set -eu

kubeadm init --config config/k8s-m1/kubeadm-config.yaml
