#!/bin/sh
# auther: york

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3 k8s-n1"}

for NODE in ${NODES}; do
    echo "====${NODE}===="
    ssh ${NODE} "yum install ipvsadm -y"
    scp ipvs.modules ${NODE}:/etc/sysconfig/modules/ipvs.modules
    ssh ${NODE} "chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep ip_vs"
done
