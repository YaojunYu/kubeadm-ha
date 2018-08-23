#!/bin/sh
# auther: york

set -eu

if [ ! -d "/root/.kubeadm" ]; then
  mkdir "/root/.kubeadm"
fi

cat <<EOF > /root/.kubeadm/kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1alpha2
kind: MasterConfiguration
kubernetesVersion: v1.11.2
apiServerCertSANs:
- k8s-m1
- k8s-m2
- k8s-m3
- k8s-m-lb
- 10.128.0.2
- 10.128.0.3
- 10.142.0.2
- 10.128.0.4
#api:
#  controlPlaneEndpoint: "10.128.0.4:6443"
etcd:
  local:
    extraArgs:
      listen-client-urls: "https://127.0.0.1:2379,https://10.128.0.2:2379"
      advertise-client-urls: "https://10.128.0.2:2379"
      listen-peer-urls: "https://10.128.0.2:2380"
      initial-advertise-peer-urls: "https://10.128.0.2:2380"
      initial-cluster: "k8s-master01=https://10.128.0.2:2380"
    serverCertSANs:
      - k8s-m1
      - 10.128.0.2
    peerCertSANs:
      - k8s-m1
      - 10.128.0.2
networking:
  # This CIDR is a Calico default. Substitute or remove for your CNI provider.
  podSubnet: "172.168.0.0/16"
EOF

kubeadm init --config /root/.kubeadm/kubeadm-config.yaml