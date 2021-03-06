#!/bin/sh
#

# 建立 bootstrap 使用者的 kubeconfig 檔

kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/pki/ca.pem \
  --embed-certs=true \
  --server=${K8S_APISERVER} \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config set-credentials tls-bootstrap-token-user \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config set-context tls-bootstrap-token-user@kubernetes \
  --cluster=kubernetes \
  --user=tls-bootstrap-token-user \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config use-context tls-bootstrap-token-user@kubernetes \
    --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

for NODE in $K8S_MASTERS; do
    scp /etc/kubernetes/bootstrap-kubelet.conf ${NODE}:/etc/kubernetes/bootstrap-kubelet.conf
done
