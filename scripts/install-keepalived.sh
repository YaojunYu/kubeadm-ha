#!/bin/sh
# auther: york

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3 k8s-n1"}

for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "yum install -y keepalived"
  ssh ${NODE} "systemctl daemon-reload && systemctl enable keepalived && systemctl restart keepalived"
  ssh ${NODE} "systemctl status keepalived"
done