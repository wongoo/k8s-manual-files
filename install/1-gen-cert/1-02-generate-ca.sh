#!/bin/sh
#

mkdir -p ${PKI_DIR}
cfssl gencert -initca pki/ca-csr.json | cfssljson -bare ${PKI_DIR}/ca

# -------------------------
ls ${PKI_DIR}/ca*
# /etc/kubernetes/pki/ca.csr  /etc/kubernetes/pki/ca-key.pem  /etc/kubernetes/pki/ca.pem

# ------------------------
# kubernetes.default為 Kubernetes 系統在 default namespace 自動建立的 API service domain name。
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=pki/ca-config.json \
  -hostname=${K8S_CLUSTER_IP},${K8S_VIP},${K8S_M1_IP},${K8S_M2_IP},${K8S_M3_IP},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  pki/apiserver-csr.json | cfssljson -bare ${PKI_DIR}/apiserver

ls ${PKI_DIR}/apiserver*
# /etc/kubernetes/pki/apiserver.csr  /etc/kubernetes/pki/apiserver-key.pem  /etc/kubernetes/pki/apiserver.pem

