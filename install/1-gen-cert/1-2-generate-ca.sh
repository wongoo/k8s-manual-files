#!/bin/sh
#

mkdir -p ${PKI_DIR}
cfssl gencert -initca ca-csr.json | cfssljson -bare ${PKI_DIR}/ca
ls ${PKI_DIR}/ca*
# /etc/kubernetes/pki/ca.csr  /etc/kubernetes/pki/ca-key.pem  /etc/kubernetes/pki/ca.pem

# 這邊-hostname的10.96.0.1是 Cluster IP 的 Kubernetes 端點;
# 10.104.113.166 為 VIP 位址;
# kubernetes.default為 Kubernetes 系統在 default namespace 自動建立的 API service domain name。
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=pki/ca-config.json \
  -hostname=10.96.0.1,10.104.113.166,127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  pki/apiserver-csr.json | cfssljson -bare ${PKI_DIR}/apiserver

ls ${PKI_DIR}/apiserver*
# /etc/kubernetes/pki/apiserver.csr  /etc/kubernetes/pki/apiserver-key.pem  /etc/kubernetes/pki/apiserver.pem

