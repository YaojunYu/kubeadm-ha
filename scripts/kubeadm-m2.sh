#!/bin/sh
# auther: york

set -eu

: ${K8S_M2:="k8s-m2"}
echo "---${K8S_M2}---"

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
      listen-client-urls: "https://127.0.0.1:2379,https://10.128.0.3:2379"
      advertise-client-urls: "https://10.128.0.3:2379"
      listen-peer-urls: "https://10.128.0.3:2380"
      initial-advertise-peer-urls: "https://10.128.0.2:2380"
      initial-cluster: "k8s-m1=https://10.128.0.2:2380,k8s-m2=https://10.128.0.3:2380"
      initial-cluster-state: existing
    serverCertSANs:
      - k8s-m2
      - 10.128.0.3
    peerCertSANs:
      - k8s-m2
      - 10.128.0.3
networking:
  # This CIDR is a Calico default. Substitute or remove for your CNI provider.
  podSubnet: "192.168.0.0/16"
EOF

export KUBEADM_CONFIG=/root/.kubeadm/kubeadm-config.yaml

kubeadm alpha phase certs all --config ${KUBEADM_CONFIG}
kubeadm alpha phase kubeconfig controller-manager --config ${KUBEADM_CONFIG}
kubeadm alpha phase kubeconfig scheduler --config ${KUBEADM_CONFIG}
kubeadm alpha phase kubelet config write-to-disk --config ${KUBEADM_CONFIG}
kubeadm alpha phase kubelet write-env-file --config ${KUBEADM_CONFIG}
kubeadm alpha phase kubeconfig kubelet --config ${KUBEADM_CONFIG}
systemctl restart kubelet

export CP0_IP=10.128.0.2
export CP0_HOSTNAME=k8s-m1
export CP1_IP=10.128.0.3
export CP1_HOSTNAME=k8s-m2

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl exec -n kube-system etcd-${CP0_HOSTNAME} -- etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt --cert-file /etc/kubernetes/pki/etcd/peer.crt --key-file /etc/kubernetes/pki/etcd/peer.key --endpoints=https://${CP0_IP}:2379 member add ${CP1_HOSTNAME} https://${CP1_IP}:2380
kubeadm alpha phase etcd local --config ${KUBEADM_CONFIG}

kubeadm alpha phase kubeconfig all --config ${KUBEADM_CONFIG}
kubeadm alpha phase controlplane all --config ${KUBEADM_CONFIG}
kubeadm alpha phase mark-master --config ${KUBEADM_CONFIG}

sed -i "s/10.128.0.2:6443/10.128.0.3:6443/g" /etc/kubernetes/admin.conf
