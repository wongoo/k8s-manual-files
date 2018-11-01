#!/bin/sh
#

cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=pki/ca-config.json \
  -profile=kubernetes \
  pki/admin-csr.json | cfssljson -bare ${PKI_DIR}/controller-manager

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=${PKI_DIR}/controller-manager.pem \
    --client-key=${PKI_DIR}/controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config set-context system:kube-controller-manager@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config use-context system:kube-controller-manager@kubernetes \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

