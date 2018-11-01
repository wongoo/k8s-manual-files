#!/bin/sh
#

cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=pki/ca-config.json \
  -profile=kubernetes \
  pki/kube-proxy-csr.json | cfssljson -bare ${PKI_DIR}/kube-proxy

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/kube-proxy.conf

kubectl config set-credentials kubernetes-kube-proxy \
    --client-certificate=${PKI_DIR}/kube-proxy.pem \
    --client-key=${PKI_DIR}/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/kube-proxy.conf

kubectl config set-context kubernetes-kube-proxy@kubernetes \
    --cluster=kubernetes \
    --user=kubernetes-kube-proxy \
    --kubeconfig=${K8S_DIR}/kube-proxy.conf

kubectl config use-context kubernetes-kube-proxy@kubernetes \
    --kubeconfig=${K8S_DIR}/kube-proxy.conf
       
