#!/bin/sh
# auther: york

set -eu
systemctl start docker

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
export CP2_IP=10.142.0.2
export CP2_HOSTNAME=k8s-m3

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl exec -n kube-system etcd-${CP0_HOSTNAME} -- etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt --cert-file /etc/kubernetes/pki/etcd/peer.crt --key-file /etc/kubernetes/pki/etcd/peer.key --endpoints=https://${CP0_IP}:2379 member add ${CP2_HOSTNAME} https://${CP2_IP}:2380
kubeadm alpha phase etcd local --config ${KUBEADM_CONFIG}

rm -rf /etc/kubernetes/admin.conf
kubeadm alpha phase kubeconfig all --config ${KUBEADM_CONFIG}
kubeadm alpha phase controlplane all --config ${KUBEADM_CONFIG}
kubeadm alpha phase mark-master --config ${KUBEADM_CONFIG}
