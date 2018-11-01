#!/bin/sh
#

cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=pki/ca-config.json \
  -profile=kubernetes \
  pki/admin-csr.json | cfssljson -bare ${PKI_DIR}/admin

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config set-credentials kubernetes-admin \
    --client-certificate=${PKI_DIR}/admin.pem \
    --client-key=${PKI_DIR}/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config set-context kubernetes-admin@kubernetes \
    --cluster=kubernetes \
    --user=kubernetes-admin \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config use-context kubernetes-admin@kubernetes \
    --kubeconfig=${K8S_DIR}/admin.conf
    
