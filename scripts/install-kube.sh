#!/bin/sh
# auther: york

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3 k8s-n1"}

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

for NODE in ${NODES}; do
  echo "---${NODE}---"
  scp /etc/yum.repos.d/kubernetes.repo ${NODE}:/etc/yum.repos.d/kubernetes.repo
  ssh ${NODE} "yum update -y"
  ssh ${NODE} "yum install -y kubelet kubeadm kubectl docker-ce"
  ssh ${NODE} "systemctl daemon-reload"
  ssh ${NODE} "systemctl enable docker && systemctl start docker"
  ssh ${NODE} "systemctl enable kubelet && systemctl start kubelet"
  ssh ${NODE} "systemctl status kubelet"
done