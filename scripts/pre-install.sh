#!/bin/sh
# auther: york

set -eu

#systemctl stop firewalld && systemctl disable firewalld
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf
swapoff -a && sysctl -w vm.swappiness=0
sed '/swap.img/d' -i /etc/fstab
sed -i 's/(^.centos-swap swap.$)/#\1/' /etc/fstab