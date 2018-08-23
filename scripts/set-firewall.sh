#!/bin/sh
#
# Program: Generate kubernetes static pod files.
# History: 2018/07/07 k2r2.bai release.

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3"}
: ${PORTS:="16443 6443 4001 2379-2380 10250 10251 10252 10255 30000-32767"}

for NODE in ${NODES}; do
  echo "---${NODE}---"
  ssh ${NODE} "systemctl enable firewalld && systemctl restart firewalld && systemctl status firewalld"
  for PORT in ${PORTS}; do
    ssh ${NODE} "firewall-cmd --zone=public --add-port=${PORT}/tcp --permanent"
  done
  ssh ${NODE} "firewall-cmd --reload && firewall-cmd --list-all --zone=public"

  ssh ${NODE} "firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 1 -i docker0 -j ACCEPT -m comment --comment 'kube-proxy redirects'"
  ssh ${NODE} "firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 1 -o docker0 -j ACCEPT -m comment --comment 'docker subnet'"
  ssh ${NODE} "firewall-cmd --reload && firewall-cmd --direct --get-all-rules"
  ssh ${NODE} "systemctl restart firewalld"
done