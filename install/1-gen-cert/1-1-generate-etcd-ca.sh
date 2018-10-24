#!/bin/sh
#

export ETCD_PKI_DIR=/etc/etcd/ssl
mkdir -p ${ETCD_PKI_DIR}
cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd-ca

cfssl gencert \
  -ca=${ETCD_PKI_DIR}/etcd-ca.pem \
  -ca-key=${ETCD_PKI_DIR}/etcd-ca-key.pem \
  -config=pki/ca-config.json \
  -hostname=127.0.0.1,${K8S_M1_IP},${K8S_M2_IP},${K8S_M3_IP} \
  -profile=kubernetes \
  pki/etcd-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd

ls ${ETCD_PKI_DIR}

for NODE in $K8S_MASTERS; do
    ssh ${NODE} "mkdir -p ${ETCD_PKI_DIR}"
    for FILE in etcd-ca-key.pem  etcd-ca.pem  etcd-key.pem  etcd.pem; do
      scp ${ETCD_PKI_DIR}/${FILE} ${NODE}:${ETCD_PKI_DIR}/${FILE}
    done
done
