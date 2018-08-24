#!/bin/sh
# auther: york

set -eu

: ${NODES:="k8s-n1"}

TOKEN=$(kubeadm token list | awk '$1!="TOKEN" && $1!="" {print $1}')
CERT_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')
for NODE in ${NODES}; do
  echo "---${NODE}---"
  echo "token:{${TOKEN}}"
  echo "cert-hash{sha256:${FINGERPRT}}"
  ssh ${NODE} "kubeadm join 10.128.0.2:6443 --token ${TOKEN} --discovery-token-ca-cert-hash sha256:${FINGERPRT}"
done